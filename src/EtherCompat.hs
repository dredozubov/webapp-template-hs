{-# LANGUAGE UndecidableInstances #-}

module EtherCompat
  ( HReaderT
  , MonadReaders
  , MonadReader
  , ask
 ) where

import           Data.HSet
import qualified Ether as E
import           GHC.Exts (Constraint)


-- | A special tag for Reader flattening using HSet.
data HSetReader_K a = HSetReader a

instance
  ( HGettable els r
  , HMonoModifiable els r
  , hset ~ HSet els
  , Monad m
  ) => E.MonadReader r r (E.ReaderT ('HSetReader els) hset m) where
  ask = undefined
  local = undefined

type HReaderT els = E.ReaderT ('HSetReader els) (HSet els)

type MonadReader r = E.MonadReader r r

ask :: forall r m . E.MonadReader' r m => m r
ask = E.ask @r

type family MonadReaders rs m :: Constraint where
  MonadReaders '[] m = ()
  MonadReaders (r ': rs) m = (E.MonadReader r r m, MonadReaders rs m)
