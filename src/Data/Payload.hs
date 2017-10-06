module Data.Payload where

import GHC.TypeLits

newtype PayloadX = PayloadX Int

data Payload (n :: Nat)
