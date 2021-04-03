module Global.Model exposing (..)

import Browser.Navigation exposing (Key)
import App.Route
import Url exposing (Url)
import App.Router
import App.Flags exposing (Flags)

type alias Model =
  { navigationKey : Key
  , page : App.Route.Route
  , jwtToken : Maybe String
  }

initialModel : Flags -> Key -> Url -> Model
initialModel flags key url =
  { navigationKey = key
  , page = App.Router.parsedUrl url
  , jwtToken = flags.jwt
  }