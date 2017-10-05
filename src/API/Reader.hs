module API.Reader where

import API.Types
import Data.Proxy
import Servant


type ReaderAPI = "reader" :> Get '[JSON] ApiResult

readerApi :: Proxy ReaderAPI
readerApi = Proxy
