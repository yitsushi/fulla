module App.Model exposing (..)

import Global.Model
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Page.SignIn.Model
import App.Flags exposing (Flags)
import Page.Gallery.Model
import App.Route
import Page.Gallery.Route

type alias Model =
  { global : Global.Model.Model
  , signIn : Page.SignIn.Model.Model
  , gallery : Page.Gallery.Model.Model
  }

initialModel : Flags -> Key -> Url -> Model
initialModel flags key url =
  let
    globalModel = Global.Model.initialModel flags key url
    signInModel = Page.SignIn.Model.initialModel
    galleryModel = case globalModel.page of
      App.Route.Gallery (Page.Gallery.Route.Show path) -> Page.Gallery.Model.initialModel path
      _ -> Page.Gallery.Model.initialModel (Just "/")
  in
  { global = globalModel
  , signIn = signInModel
  , gallery = galleryModel
  }