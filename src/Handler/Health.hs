module Handler.Health where

import API.Types


handleHealthRequest :: ApiStatus
handleHealthRequest = ApiStatus "ok"
