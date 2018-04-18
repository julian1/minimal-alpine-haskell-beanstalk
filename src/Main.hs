
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai(Application, Request, Response, ResponseReceived, pathInfo, queryString, responseLBS) 
import Network.Wai.Handler.Warp (setPort, runSettings, setLogger, defaultSettings)
import Network.HTTP.Types (status200, status404, Status)
import Network.HTTP.Types.Header (hContentType)

import qualified Data.ByteString.Lazy.Char8 as LBS(empty, concat, pack)
import System.Environment(getExecutablePath, getArgs, getEnvironment, lookupEnv)
import System.IO(hSetBuffering, stdout, BufferMode(..))
import Data.Foldable(foldlM)


import qualified Config

-- change to Text or Bytestring?
put = Prelude.putStr
puts = Prelude.putStrLn



--  https://hackage.haskell.org/package/wai-logger-2.3.2/docs/Network-Wai-Logger.html
requestLogger :: Request -> Status -> Maybe Integer -> IO ()
requestLogger req stat i = do
  put "requestLogger "
  put $ maybe "" show i
  put . show. pathInfo $ req
  put "\n"




main :: IO ()
main = do
    -- set stdout buffering,
    -- https://stackoverflow.com/questions/12435794/putstrln-doesnt-print-to-console
    hSetBuffering stdout LineBuffering


    -- app path for resources
    --  if APP_PATH is defined in env, use it, otherwise use relative path
    path' <- lookupEnv "APP_PATH"
    let appPath = maybe "." id path'

    puts . (++) "appPath: " $ appPath

    -- read config
    config_ <- Config.getConfig $ appPath ++ "/Config.json"

    config <- case config_ of 
        Nothing -> do 
          -- fail
          let s = "Failed to get config"
          puts s 
          -- fail runs in IO monad, and is recommended
          -- http://www.randomhacks.net/2007/03/10/haskell-8-ways-to-report-errors/
          fail s 
        Just ci -> do
          puts "Read config OK"
          return ci

    let warpSettings =
          setPort (Config.port config)
          $ setLogger requestLogger
          $ defaultSettings


    puts . (++) "Listening on port " . show . Config.port $ config

    runSettings warpSettings $ app


app :: Application
app req res =  do
  let params =  queryString req
  case (pathInfo req) of
    [ ]             -> env req
    [ "env" ]       -> env req
    [ "hello" ]     -> hello
    _               -> notFound
    >>= res


env :: Request -> IO Response
env req = do

  puts "got env"
  path <- getExecutablePath
  args <- getArgs
  env <- getEnvironment

  -- create args as kv list
  let argList = zipWith (\k v -> return $ "param" ++ show k ++ ":" ++ v)  [0..] args

  -- concat, with other
  env <- return $
    [ ("executablePath", path) ]
    ++ argList
    ++ env
    ++ [ ("request", show req) ]

  body <- foldlM formatKV LBS.empty env

  return $ responseLBS status200 [(hContentType, "text/plain")] body

  where formatKV s (k,v) = do
          return $ LBS.concat [ s, LBS.pack k, ":", LBS.pack v, "\n" ]


hello :: IO Response
hello = do
  puts "got hello"
  return $ responseLBS status200 [(hContentType, "application/json")] "\"Hello World!\""


notFound :: IO Response
notFound = do
  puts "got not found"
  return $ responseLBS status404 [(hContentType, "application/json")] "\"404 - Not Found\""


