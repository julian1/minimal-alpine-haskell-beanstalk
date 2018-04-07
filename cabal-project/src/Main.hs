{-
-}

{-# LANGUAGE ScopedTypeVariables, OverloadedStrings, PartialTypeSignatures #-}

module Main where


import Network.Wai(responseLBS, Application, Response, pathInfo, rawPathInfo,
    requestMethod, remoteHost, requestHeaders, queryString, rawQueryString,
    Request, ResponseReceived, requestBody )


import Network.Wai.Handler.Warp (run, setPort, getPort, setLogger, defaultSettings, runSettings)
import Network.HTTP.Types (status200, status404, Status )
import Network.HTTP.Types.Header (hContentType, hContentEncoding)

import Network.Wai.Logger(withStdoutLogger)


import qualified Data.ByteString.Char8 as BS(empty, putStrLn, pack, unpack, concat, readInt, split)
import qualified Data.ByteString.Lazy.Char8 as LBS(empty, putStrLn, pack, unpack, concat, readFile, fromChunks)

import qualified Data.Pool as Pool(createPool, withResource, Pool)
import qualified Database.PostgreSQL.Simple as PG(connect, close, query, Connection, defaultConnectInfo)
import Database.PostgreSQL.Simple.Types as PG(Only(..))


-- import qualified Data.Binary as DB(encode)
import qualified Text.Show.ByteString as BS(show)
-- import qualified Text.Show.LazyByteString as LBS(show)


-- this is a pretty heavy dependency -  memory, foundation, mime, cryptonite
import Network.Wai.Middleware.Static


import Data.Foldable(foldlM)

import Data.Bool.Extras(bool)

import System.Environment(getExecutablePath, getArgs, getEnvironment, lookupEnv)

-- import Data.List.Split(splitOn)

import System.IO( hSetBuffering , stdout, BufferMode(LineBuffering))

--------
-- Local Modules

import Person(getPersonJSON)

import qualified Config as Config(getConnectionInfo)

put = putStr
puts = putStrLn

-- OK. we want to run this entire project locally. but without docker.
-- that means push to git, and pull again the changes - for

{-
  https://hackage.haskell.org/package/wai-logger-2.3.2/docs/Network-Wai-Logger.html
-}
requestLogger :: Request -> Status -> Maybe Integer -> IO ()
requestLogger req stat i = do
  put "requestLogger "
  put $ maybe "" show i
  put . show. pathInfo $ req
  put "\n"


{-
  nice example see, https://hackage.haskell.org/package/wai-extra-3.0.7.1/src/Network/Wai/Middleware/RequestLogger.hs
  The only thing we can do, with logging - is log after everything is complete. due to laziness.
  not sure this helps us that much...
  https://stackoverflow.com/questions/16337989/how-can-i-log-an-entire-http-request-in-wai-scotty
  -- issue is sequencing stuff in the log, correctly in the log...
-}

middlewareLogger :: Application -> Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
-- middlewareLogger :: Application -> Application
middlewareLogger app req respond = do
  put "middlewareLogger"
  put . show $ req
  put "\n"
  -- IMPORTANT - even if we can pass something down to the app here...
  -- note sure how useful wrapping application, in a CSP style really is.
  app req respond





main :: IO ()
main = do

    -- withStdoutLogger $ \logger -> do

    -- TODO expose pool parameters to config...

    -- set stdout buffering,
    -- https://stackoverflow.com/questions/12435794/putstrln-doesnt-print-to-console
    hSetBuffering stdout LineBuffering


    -- app path for resources
    --   if APP_PATH is defined in env, use it, otherwise use relative path
    path' <- lookupEnv "APP_PATH"
    let appPath = maybe "." id path'

    putStrLn $ "appPath: " ++ appPath

    -- read connection Info
    connectionInfo <- Config.getConnectionInfo $ appPath ++ "/Config.json"

    connectionInfo' <- case connectionInfo of 
        Nothing -> do 
          -- fail
          let s = "Failed to get connectionInfo"
          puts s 
          -- fail runs in IO monad
          -- http://www.randomhacks.net/2007/03/10/haskell-8-ways-to-report-errors/
          fail s 
        Just ci -> do
          puts "Read connectionInfo OK"
          return ci

    -- create conn pool
    pool <- Pool.createPool (PG.connect connectionInfo') PG.close 1 10 10

    let warpSettings =
          setPort 3000
          $ setLogger requestLogger
          $ defaultSettings


    let rewriteRules =
          rewrite "" "index.html"
          >-> rewrite "whoot" "index.html"


    let staticBase = appPath ++ "/static"

    putStrLn $ "staticBase: " ++ staticBase

    let staticMiddleware = staticPolicy (noDots >-> rewriteRules >-> addBase staticBase)


    putStrLn $ (++) "Listening on port " $ Prelude.show . getPort $ warpSettings

    runSettings warpSettings $ middlewareLogger $ staticMiddleware $ app pool
    -- runSettings warpSettings $ staticMiddleware $ app pool



-- https://github.com/scotty-web/wai-middleware-static/issues/16
rewrite :: String -> String -> Policy
rewrite from to = policy $ pure . change from to
  where
    change from to = (== from) >>= bool id (const to)




-- app :: Pool.Pool PG.Connection -> Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
app :: Pool.Pool PG.Connection -> Application
app pool req res =  do

  let params =  queryString req

  -- TODO check if this works for POST and GET?
  case (pathInfo req) of
    -- "/" is handled by static middleware
    [ "env" ]     -> env req
    [ "hello" ]   -> hello
    [ "person" ]  -> person
    [ "test" ]    -> Pool.withResource pool $ test
    _ -> notFound
    >>= res



env :: Request -> IO Response
env req = do
  puts "got env"

  path <- getExecutablePath
  args <- getArgs
  env <- getEnvironment

  -- create args as kv list
  let argList = zipWith (\k v -> return $ "param" ++ show k ++ ":" ++ v)  [0..] args

  -- concat
  env <- return $
    [ ("executablePath", path) ]
    ++ argList
    ++ env
    ++ [ ("request", show req) ]

  -- format kv
  -- weird... doing this without a IO monadic fold hangs.
  body <- foldlM formatKV LBS.empty env

  return $ responseLBS status200 [(hContentType, "text/plain")] body

  where formatKV s (k,v) = do
          return $ LBS.concat [ s, LBS.pack k, ":", LBS.pack v, "\n" ]



test :: PG.Connection -> IO Response
test conn = do
  puts "got test with conn"

  let query = "select pg_sleep(1); select 123 + 1"

  xs :: [ (Only Int ) ] <- PG.query conn query ()

  -- Note, Bytestring.show works with Maybe types... nice!
  let body =
       case xs of
          [ Only value ] -> Just value
          _ -> Nothing

  return $ responseLBS status200 [(hContentType, "text/plain")] (BS.show body)


person :: IO Response
person = do
  puts "got person"
  let body = Person.getPersonJSON
  return $ responseLBS status200 [(hContentType, "application/json")] body


hello :: IO Response
hello = do
  puts "got hello"
  return $ responseLBS status200 [(hContentType, "application/json")] "\"Hello World!\""
  -- return $ responseLBS status200 [(hContentType, "application/json")] $ (return "whoot") >>= liftIO . putStrLn . show


notFound :: IO Response
notFound = do
  puts "got not found"
  return $ responseLBS status404 [(hContentType, "application/json")] "\"404 - Not Found\""


