module Page.Gallery.Update exposing (..)

import App.Message as Base
import App.Model
import App.Route
import App.Router
import Page.Gallery.Message
import Page.Gallery.Model exposing (Model)
import Page.Gallery.Request as Request
import Page.Gallery.Route
import Global.Message


update : Base.Message -> App.Model.Model -> Model -> ( Model, Cmd Base.Message )
update msg global model =
    case msg of
        Base.Gallery (Page.Gallery.Message.ObjectListArrived response) ->
            case response of
                Ok list ->
                    ( { model | objectList = Just list }, Cmd.none )

                _ ->
                    ( { model | error = Just "something went wrong" }, Cmd.none )

        Base.Global (Global.Message.UrlChanged url) ->
            case App.Router.parsedUrl url of
                App.Route.Gallery (Page.Gallery.Route.Show p) ->
                    let
                        newModel = Debug.log "neModel" {model | path = Maybe.withDefault "/" p }
                        _ = Debug.log "msg" msg
                    in
                    ( newModel, Request.objectsOnPath global.global.jwtToken newModel <| Request.wrapMsg Page.Gallery.Message.ObjectListArrived )
                _ -> ( model, Cmd.none )
        _ ->
            case model.objectList of
                Nothing ->
                    ( model, Request.objectsOnPath global.global.jwtToken model <| Request.wrapMsg Page.Gallery.Message.ObjectListArrived )
                _ ->
                    ( model, Cmd.none )
