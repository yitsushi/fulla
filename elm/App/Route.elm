module App.Route exposing (..)

import Global.Route as Global
import Page.SignIn.Route as SignIn
import App.Message
import Browser.Navigation
import Page.Gallery.Route as Gallery

type Route
    = Global Global.Route
    | SignIn SignIn.Route
    | Gallery Gallery.Route

redirectCommand : Route -> Browser.Navigation.Key -> Maybe String -> Cmd App.Message.Message
redirectCommand page nav jwt = case jwt of
            Just _ ->
                case page of
                    Gallery _ -> Cmd.none
                    Global Global.NotFound -> Cmd.none
                    Global (Global.SomethingWentWrong _) -> Cmd.none
                    _ -> Browser.Navigation.pushUrl nav "/gallery"
            Nothing ->
                case page of
                    SignIn _ -> Cmd.none
                    _ -> Browser.Navigation.pushUrl nav "/signin"