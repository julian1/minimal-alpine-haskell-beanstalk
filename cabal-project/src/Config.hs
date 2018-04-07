{-
  https://github.com/bos/aeson/blob/master/examples/Simplest.hs
  we cannot use generic deriving because we didn't author the 
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}

module Config where

import qualified Database.PostgreSQL.Simple as PG( defaultConnectInfo, ConnectInfo(..))

import GHC.Generics

import Data.Aeson


import Control.Applicative (empty)
import qualified Data.ByteString.Lazy.Char8 as BL

{-
connectionInfo :: PG.ConnectInfo
-- connectionInfo = PG.defaultConnectInfo {
connectionInfo = PG.ConnectInfo {
      PG.connectHost = "postgres.localnet2"
    , PG.connectPort = 5432
    , PG.connectDatabase = "test"
    , PG.connectUser = "test"
    , PG.connectPassword = "test"
}
-}


instance ToJSON PG.ConnectInfo where 
  toJSON (PG.ConnectInfo host port db user pass)   =  object [
     "connectHost" .= host, 
     "connectPort" .= port, 
     "connectDatabase" .= db, 
     "connectUser" .= user,
     "connectPassword" .= pass 
    ] 
   -- toEncoding Coord{..} =


instance FromJSON PG.ConnectInfo where 
  parseJSON (Object v) = PG.ConnectInfo <$> 
      v .: "connectHost"  <*> 
      v .: "connectPort" <*> 
      v .: "connectDatabase" <*> 
      v .: "connectUser" <*> 
      v .: "connectPassword"  

  parseJSON _ = empty

{-
getConnectionInfo :: String -> IO  (Maybe PG.ConnectInfo)
getConnectionInfo fileName = do
  -- think all the IO handling might be done better in main...
  s <- BL.readFile fileName
  let c = decode s :: Maybe PG.ConnectInfo 
  return c 

-}


data Config = Config { 

    port :: Int  , 
    connectInfo :: PG.ConnectInfo 
}
  deriving (Show, Eq, Generic, ToJSON, FromJSON) -- deriving (Show, Eq)



getConfig :: String -> IO  (Maybe Config )
getConfig fileName = do
  -- think all the IO handling might be done better in main...
  s <- BL.readFile fileName
  let c = decode s :: Maybe Config
  return c 


test = do 
  j <- getConfig "Config.json"
  print j


 
  -- print $ encode PG.defaultConnectInfo 

{- 
test = do 
  j <- getConnectionInfo "Config.json"
  print j
-} 



-- type MyConnectInfo = PG.ConnectInfo
--    deriving (Show, Eq)
-- can we write aeson functions


{-
instance FromJSON Coord where
  parseJSON (Object v) = Coord <$>
                         v .: "x" <*>
                         v .: "y"
  parseJSON _ = empty

    let m = PG.ConnectInfo <$> v .: "connectHost" <*> v .: "connecPort" <*> v .: "connectDatabase" <*> v .: "connectUser" <*> v .: "connectPassword"  in
-}


  -- BL.putStrLn (encode connectionInfo )

-- deriving (Show, Eq, Generic, ToJSON, FromJSON) -- deriving (Show, Eq)
-- poolInfo

{-
instance ToJSON Coord where
  toJSON (Coord xV yV) = object [ "x" .= xV,
                                  "y" .= yV ]

  toEncoding Coord{..} = pairs $
    "x" .= x <>
  "y" .= y
-}
