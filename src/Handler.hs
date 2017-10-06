module Handler where

import Data.Payload
import EtherCompat as EC
import Servant


type Reader1API = "reader1" :> Get '[JSON] Int
type Reader2API = "reader2" :> Get '[JSON] Int

handleReaderRequest :: (MonadReaders '[PayloadX] m) => m Int
handleReaderRequest = do
  PayloadX v <- EC.ask
  return v

handleReaderRequest' :: (MonadReader PayloadX m) => m Int
handleReaderRequest' = do
  PayloadX v <- EC.ask
  return v
