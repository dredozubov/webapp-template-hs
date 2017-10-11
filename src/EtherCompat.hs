{-# LANGUAGE UndecidableInstances #-}
module EtherCompat where

import           Data.HSet
import qualified Ether as E
import           GHC.Exts (Constraint)


-- | A special tag for Reader flattening using HSet.
data HSetReader_K (xs :: [*])

instance
  ( HGettable els r
  , HMonoModifiable els r
  , hset ~ HSet els
  , Monad m
  ) => E.MonadReader r r (E.ReaderT (HSetReader_K els) hset m) where
  ask = undefined

type HReaderT els = E.ReaderT (HSetReader_K els) (HSet els)

type MonadReader r = E.MonadReader r r

ask :: E.MonadReader r r m => m r
ask = undefined

type family MonadReaders rs m :: Constraint where
  MonadReaders '[] m = ()
  MonadReaders (r ': rs) m = (E.MonadReader r r m, MonadReaders rs m)
