{-# LANGUAGE UndecidableInstances #-}
module EtherCompat where

import qualified Control.Monad.Reader as T
import           Data.Coerce
import           Data.HSet
import qualified Ether as E
import           GHC.Exts (Constraint)


-- | A special tag for Reader flattening using HSet.
data HSetReader_K (xs :: [*])

-- | Type-restricted 'coerce'.
pack :: trans m a -> E.TaggedTrans tag trans m a
pack = coerce

-- | Type-restricted 'coerce'.
unpack :: E.TaggedTrans tag trans m a -> trans m a
unpack = coerce

instance
  ( HGettable els r
  , HMonoModifiable els r
  , hset ~ HSet els
  , Monad m
  ) => E.MonadReader r r (E.ReaderT (HSetReader_K els) hset m) where
  ask _ = pack (hget <$> T.ask)
  local _ f = pack . T.local (hMonoModify f) . unpack

type HReaderT els = E.ReaderT (HSetReader_K els) (HSet els)

type MonadReader r = E.MonadReader r r

ask :: E.MonadReader r r m => m r
ask = undefined

type family MonadReaders rs m :: Constraint where
  MonadReaders '[] m = ()
  MonadReaders (r ': rs) m = (E.MonadReader r r m, MonadReaders rs m)
