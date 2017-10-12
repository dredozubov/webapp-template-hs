{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE UndecidableInstances #-}
module Data.HSet where

import TypeFun.Data.List
import TypeFun.Data.Peano

data HSet (elems :: [*]) where
  HSNil  :: HSet '[]
  HSCons :: (NotElem elem elems) => !elem -> HSet elems -> HSet (elem ': elems)

-- HGet

class (i ~ (IndexOf e els)) => HGet els e i | els i -> e where
  -- | Gets any data from HSet for you
  hget :: HSet els -> e

instance HGet (e ': els) e 'Z where
  hget (HSCons e _) = e

instance (('S i) ~ (IndexOf e (e1 ': els)), HGet els e i)
         => HGet (e1 ': els) e ('S i) where
  hget (HSCons _ els) = hget els

-- | Enables deriving of the fact that 'e' is contained within 'els' and it's
-- safe to say that 'hget' can be performed on this particular pair.
type HGettable els e = HGet els e (IndexOf e els)

-- HModify

class (i ~ (IndexOf e1 els1), i ~ (IndexOf e2 els2))
      => HModify els1 els2 e1 e2 i
       | els1 els2 e2 i -> e1  , els1 els2 e1 i -> e2
       , els1 e1 e2 i   -> els2, els2 e1 e2 i   -> els1 where
  hmodify :: (e1 -> e2) -> HSet els1 -> HSet els2

instance (NotElem e2 els)
         => HModify (e1 ': els) (e2 ': els) e1 e2 'Z where
  hmodify f (HSCons e els) = HSCons (f e) els

instance ( ('S i) ~ (IndexOf e1 (ex ': els1))
         , ('S i) ~ (IndexOf e2 (ex ': els2))
         , HModify els1 els2 e1 e2 i
         , NotElem ex els2 )
         => HModify (ex ': els1) (ex ': els2) e1 e2 ('S i) where
  hmodify f (HSCons e els) = HSCons e $ hmodify f els

-- | Check that we can turn one hset to another
type HModifiable els1 els2 e1 e2 = HModify els1 els2 e1 e2 (IndexOf e1 els1)

-- | Helper type infering that hset 'els' contains element of type 'e'
-- and can be modified
type HMonoModifiable els e = HModifiable els els e e
