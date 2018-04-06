
module Config where

import qualified Database.PostgreSQL.Simple as PG( defaultConnectInfo, ConnectInfo(..))


import Data.Aeson

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



instance ToJSON PG.ConnectInfo
  where toJSON (PG.ConnectInfo a b c d e )   =  object [] 

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
