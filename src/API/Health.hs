module API.Health where

import API.Types
import Data.Proxy
import Servant


type HealthAPI = "health" :> Get '[JSON] ApiStatus

healthApi :: Proxy HealthAPI
healthApi = Proxy
