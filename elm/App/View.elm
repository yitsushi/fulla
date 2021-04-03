module App.View exposing (..)

import App.Message as Message
import App.Model as Model
import App.Route
import Browser exposing (Document)
import Global.View
import Html
import Html.Attributes
import Page.SignIn.View
import Page.Gallery.View


view : Model.Model -> Document Message.Message
view model =
    { title = "Fulla"
    , body =
        [ Html.div
            [ Html.Attributes.class "content" ]
            (case model.global.page of
                App.Route.Global page ->
                    Global.View.view page model

                App.Route.Gallery page ->
                    Page.Gallery.View.view page model

                App.Route.SignIn page ->
                    Page.SignIn.View.view page model
            )
        ]
    }