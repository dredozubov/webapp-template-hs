{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE KindSignatures     #-}
{-# LANGUAGE PolyKinds          #-}
{-# LANGUAGE FunctionalDependencies  #-}
{-# LANGUAGE UndecidableInstances  #-}
module Servant where

import Control.Monad.Except (ExceptT)
import Control.Natural ((:~>)(..))
import GHC.TypeLits


-- Verbs

data Verb (method :: k1) (statusCode :: Nat) (contentTypes :: [*]) (a :: *)

data Method = GET | PUT

type Get    = Verb 'GET    200
type Put    = Verb 'PUT    200

data JSON

-- Alternative

data a :<|> b = a :<|> b
infixr 3 :<|>

-- Handler

data ServantErr

newtype Handler a = Handler { runHandler' :: ExceptT ServantErr IO a }

-- Server

class HasServer api context where
  type ServerT api (m :: * -> *) :: *

type Server api = ServerT api Handler

instance (HasServer a context, HasServer b context) => HasServer (a :<|> b) context where
  type ServerT (a :<|> b) m = ServerT a m :<|> ServerT b m

instance {-# OVERLAPPABLE #-}
         ( KnownNat status
         ) => HasServer (Verb method status ctypes a) context where

  type ServerT (Verb method status ctypes a) m = m a

-- Enter

newtype Tagged s b = Tagged { unTagged :: b }

retag :: Tagged s b -> Tagged t b
retag = Tagged . unTagged

-- | Helper type family to state the 'Enter' symmetry.
type family Entered m n api where
    Entered m n (a -> api)       = a -> Entered m n api
    Entered m n (m a)            = n a
    Entered m n (api1 :<|> api2) = Entered m n api1 :<|> Entered m n api2
    Entered m n (Tagged m a)     = Tagged n a

class
    ( Entered m n typ ~ ret
    , Entered n m ret ~ typ
    ) => Enter typ m n ret | typ m n ->  ret, ret m n -> typ, ret typ m -> n, ret typ n -> m
  where
    -- | Map the leafs of an API type.
    enter :: (m :~> n) -> typ -> ret

-- ** Servant combinators

instance
    ( Enter typ1 m1 n1 ret1, Enter typ2 m2 n2 ret2
    , m1 ~ m2, n1 ~ n2
    , Entered m1 n1 (typ1 :<|> typ2) ~ (ret1 :<|> ret2)
    , Entered n1 m1 (ret1 :<|> ret2) ~ (typ1 :<|> typ2)
    ) => Enter (typ1 :<|> typ2) m1 n1 (ret1 :<|> ret2)
  where
    enter e (a :<|> b) = enter e a :<|> enter e b

instance
    ( Enter typ m n ret
    , Entered m n (a -> typ) ~ (a -> ret)
    , Entered n m (a -> ret) ~ (a -> typ)
    ) => Enter (a -> typ) m n (a -> ret)
  where
    enter arg f a = enter arg (f a)

-- ** Leaf instances

instance
    ( Entered m n (Tagged m a) ~ Tagged n a
    , Entered n m (Tagged n a) ~ Tagged m a
    ) => Enter (Tagged m a) m n (Tagged n a)
  where
    enter _ = retag

instance
    ( Entered m n (m a) ~ n a
    , Entered n m (n a) ~ m a
    ) => Enter (m a) m n (n a)
  where
    enter (NT f) = f
