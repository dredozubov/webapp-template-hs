module Runner where

import Data.Payload
import Data.Proxy
import EtherCompat
import Handler
import Servant as S


type API =
  Reader1API :<|> Reader2API

api :: Proxy API
api = Proxy

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

app :: Application
app = serve api server
