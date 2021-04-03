module Page.Gallery.Update exposing (..)

import App.Message as Base
import App.Model
import Page.Gallery.Model exposing (Model)
import Page.Gallery.Request as Request
import Page.Gallery.Message


update : Base.Message -> App.Model.Model -> Model -> ( Model, Cmd Base.Message )
update msg  global model =
    case model.objectList of
        Nothing ->
            case msg of
                Base.Gallery (Page.Gallery.Message.ObjectListArrived response) ->
                    case response of
                        Ok list -> ( { model | objectList = Just list }, Cmd.none )
                        _ -> ( { model | error = Just "something went wrong" }, Cmd.none )
                _ -> ( model, Request.objectsOnPath global.global.jwtToken model <| Request.wrapMsg Page.Gallery.Message.ObjectListArrived )
        Just _ -> ( model, Cmd.none )