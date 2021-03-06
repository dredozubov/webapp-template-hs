module Runner where

import API
import Data.Proxy
import Handler
import Network.Wai.Handler.Warp (run)
import Servant


type API = HealthAPI

api :: Proxy API
api = Proxy

server :: Server API
server = pure handleHealthRequest

app :: Application
app = serve api server

launch :: IO ()
launch = run 8080 app
