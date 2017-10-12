module Runner where

import Data.Payload
import Data.Proxy
import EtherCompat as EC
import Servant as S

import Control.Natural


type API =
  Reader1API :<|> Reader2API

api :: Proxy API
api = Proxy

type Reader1API = Get '[JSON] Int
type Reader2API = Put '[JSON] Int

handleReaderRequest :: (MonadReaders '[PayloadX] m) => m Int
handleReaderRequest = do
  PayloadX v <- EC.ask
  return v

handleReaderRequest' :: (MonadReader PayloadX m) => m Int
handleReaderRequest' = do
  PayloadX v <- EC.ask
  return v


type AppPayload =
  '[ Payload 1
   , Payload 2
   , Payload 3
   , Payload 4
   , Payload 5
   , Payload 6
   , Payload 7
   , Payload 8
   , Payload 9
   , Payload 10
   , PayloadX
   ]

type AppServer = HReaderT AppPayload IO

appToHandler :: AppServer :~> S.Handler
appToHandler = undefined

server :: Server API
server = enter appToHandler mainH
  where
    mainH =
      handleReaderRequest' :<|> handleReaderRequest
