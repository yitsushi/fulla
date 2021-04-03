module App.Init exposing (..)

import App.Flags exposing (Flags)
import App.Message exposing (Message)
import App.Model exposing (Model, initialModel)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import App.Route

init : Flags -> Url -> Key -> ( Model, Cmd Message )
init flags url key =
    let
        model = initialModel flags key url
        command = App.Route.redirectCommand model.global.page model.global.navigationKey model.global.jwtToken
    in
        ( model, command )