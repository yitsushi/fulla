module App.Init exposing (..)

import App.Flags exposing (Flags)
import App.Message exposing (Message)
import App.Model exposing (Model, initialModel)
import Browser.Navigation exposing (Key)
import Url exposing (Url)


init : Flags -> Url -> Key -> ( Model, Cmd Message )
init flags url key =
    ( initialModel flags key url, Cmd.none )