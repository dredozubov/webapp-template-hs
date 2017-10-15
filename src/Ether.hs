{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Ether where

import qualified Control.Monad.Reader as T

class Monad m => MonadReader tag r m | m tag -> r where
  ask :: proxy tag -> m r
  local :: proxy tag -> (r -> r) -> m a -> m a

-- | Tagged monad transformer.
newtype TaggedTrans tag trans (m :: * -> *) a = TaggedTrans (trans m a)
  deriving (Functor, Applicative, Monad)

type ReaderT tag r = TaggedTrans tag (T.ReaderT r)
