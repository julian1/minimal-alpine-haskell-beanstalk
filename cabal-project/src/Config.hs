{-
  https://github.com/bos/aeson/blob/master/examples/Simplest.hs
-}

{-# LANGUAGE OverloadedStrings #-}

module Config where

import qualified Database.PostgreSQL.Simple as PG( defaultConnectInfo, ConnectInfo(..))


import Data.Aeson

import qualified Data.ByteString.Lazy.Char8 as BL

-- type MyConnectInfo = PG.ConnectInfo
--    deriving (Show, Eq)
-- can we write aeson functions

connectionInfo :: PG.ConnectInfo
connectionInfo = PG.defaultConnectInfo {
      PG.connectHost = "postgres.localnet2"
    , PG.connectPort = 5432
    , PG.connectDatabase = "test"
    , PG.connectUser = "test"
    , PG.connectPassword = "test"
}


instance ToJSON PG.ConnectInfo where 
  toJSON (PG.ConnectInfo host port db user pass)   =  object [
     "connectHost" .= host, 
     "connectPort" .= port, 
     "connectDatabase" .= db, 
     "connectUser" .= user,
     "connectPassword" .= pass 
    ] 


{-
instance FromJSON Coord where
  parseJSON (Object v) = Coord <$>
                         v .: "x" <*>
                         v .: "y"
  parseJSON _ = empty
-}

instance FromJSON PG.ConnectInfo where 
  parseJSON (Object v) = PG.ConnectInfo   <$> v .: "connectHost"
                          <*> v .: "connecPort"
                          <*> v .: "connectDatabase"
                          <*> v .: "connectUser"
                          <*> v .: "connectPassword"

      -- "connectHost" .= host, 
    



myfunc = do
  BL.putStrLn (encode connectionInfo )

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
