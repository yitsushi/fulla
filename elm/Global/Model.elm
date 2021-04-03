module Global.Model exposing (..)

import Browser.Navigation exposing (Key)
import App.Route
import Url exposing (Url)
import App.Router

type alias Model =
  { navigationKey : Key
  , page : App.Route.Route
  , jwtToken : Maybe String
  }

initialModel : Key -> Url -> Model
initialModel key url =
  { navigationKey = key
  , page = App.Router.parsedUrl url
  , jwtToken = Nothing
  }