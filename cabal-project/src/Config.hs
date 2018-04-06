
module Config where

import qualified Database.PostgreSQL.Simple as PG( defaultConnectInfo, ConnectInfo(..))


connectionInfo :: PG.ConnectInfo
connectionInfo = PG.defaultConnectInfo { 
      PG.connectHost = "postgres.localnet2"
    , PG.connectPort = 5432
    , PG.connectDatabase = "test"
    , PG.connectUser = "test"
    , PG.connectPassword = "test"
}

-- poolInfo

