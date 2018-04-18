
{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

module Config where


import GHC.Generics
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BL



data Config = Config {
    -- http port
    port :: Int
} deriving (Show, Eq, Generic, ToJSON, FromJSON)



getConfig :: String -> IO  (Maybe Config )
getConfig fileName = do
  s <- BL.readFile fileName
  let c = decode s :: Maybe Config
  return c

{-
test = do
  j <- getConfig "Config.json"
  print j

-}
