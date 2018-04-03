
{-
    https://artyom.me/aeson#records-and-json-generics
  
    Note. that using json as alternative to Show is quite nice because uses BS rather than [] String.

    - note how nicely it handles Maybe type!.
-}

{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}



module Person where


import GHC.Generics
import Data.Aeson

-- import qualified Data.ByteString.Char8 as BS(putStrLn) --, pack, concat, readInt, split)

import qualified Data.ByteString.Lazy.Char8 as LBS(putStrLn) -- unpack, readFile, fromChunks)


data Person = Person
  { name :: Maybe String
  , age :: Int
}
  deriving (Show, Eq, Generic, ToJSON, FromJSON) -- deriving (Show, Eq)



getPersonJSON = 
  -- let j = Person { name = Just "me", age = 32 } in
  let j = Person { name = Nothing , age = 32 } in

  encode j



