module Page.Gallery.Update exposing (..)

import App.Message as Base
import App.Model
import App.Route
import App.Router
import Global.Message
import Page.Gallery.Message
import Page.Gallery.Model exposing (Model, nextImage)
import Page.Gallery.Request as Request
import Page.Gallery.Route
import Page.Gallery.Message exposing (Message(..))

update : Base.Message -> App.Model.Model -> Model -> ( Model, Cmd Base.Message )
update msg global model =
    case msg of
        Base.Gallery (Page.Gallery.Message.ObjectListArrived response) ->
            case response of
                Ok list ->
                    ( { model | objectList = Just list }, Cmd.none )

                _ ->
                    ( { model | error = Just "something went wrong" }, Cmd.none )

        Base.Gallery (Page.Gallery.Message.Enlarge path) ->
            ( { model | enlarge = Just path }, Cmd.none )

        Base.Gallery Page.Gallery.Message.Shrink ->
            ( { model | enlarge = Nothing }, Cmd.none )

        Base.KeyEvent evt ->
            let
                pureObjectList = Maybe.withDefault [] model.objectList
                extendedObjectList = pureObjectList ++ pureObjectList
                purePath = Maybe.withDefault "" model.enlarge
            in
                case evt.key of
                    "Escape" -> ( { model | enlarge = Nothing }, Cmd.none )
                    "ArrowLeft" -> ( { model | enlarge = nextImage (List.reverse extendedObjectList) False purePath }, Cmd.none )
                    "ArrowRight" -> ( { model | enlarge = nextImage extendedObjectList False purePath }, Cmd.none )
                    _ -> ( model, Cmd.none )

        Base.Global (Global.Message.UrlRequest _) ->
            ( { model | objectList = Nothing }, Cmd.none )

        Base.Global (Global.Message.UrlChanged url) ->
            case App.Router.parsedUrl url of
                App.Route.Gallery (Page.Gallery.Route.Show p) ->
                    let
                        newModel =
                            { model | path = Maybe.withDefault "/" p }
                    in
                    ( newModel, Request.objectsOnPath global.global.jwtToken newModel <| Request.wrapMsg Page.Gallery.Message.ObjectListArrived )

                _ ->
                    ( model, Cmd.none )

        _ ->
            case model.objectList of
                Nothing ->
                    ( model, Request.objectsOnPath global.global.jwtToken model <| Request.wrapMsg Page.Gallery.Message.ObjectListArrived )

                _ ->
                    ( model, Cmd.none )
