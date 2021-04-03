module App.Model exposing (..)

import Global.Model
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Page.SignIn.Model
import App.Flags exposing (Flags)

type alias Model =
  { global : Global.Model.Model
  , signIn : Page.SignIn.Model.Model
  }

initialModel : Flags -> Key -> Url -> Model
initialModel flags key url =
  { global = Global.Model.initialModel flags key url
  , signIn = Page.SignIn.Model.initialModel
  }