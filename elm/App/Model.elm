module App.Model exposing (..)

import Global.Model
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Page.SignIn.Model
import App.Flags exposing (Flags)
import Page.Gallery.Model

type alias Model =
  { global : Global.Model.Model
  , signIn : Page.SignIn.Model.Model
  , gallery : Page.Gallery.Model.Model
  }

initialModel : Flags -> Key -> Url -> Model
initialModel flags key url =
  { global = Global.Model.initialModel flags key url
  , signIn = Page.SignIn.Model.initialModel
  , gallery = Page.Gallery.Model.initialModel
  }