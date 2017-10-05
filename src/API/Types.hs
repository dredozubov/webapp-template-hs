module API.Types where

import Data.Aeson
import Data.Text
import GHC.Generics (Generic)


newtype ApiStatus = ApiStatus Text
  deriving (Eq, Show, Generic)

instance ToJSON ApiStatus where
  toJSON (ApiStatus a) = object [ "status" .= a ]

instance FromJSON ApiStatus where
  parseJSON = withObject "ApiStatusOk" $ \v -> ApiStatus
    <$> v .: "status"

newtype ApiResult = ApiResult Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)
