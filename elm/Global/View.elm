module Global.View exposing (..)

import App.Message
import App.Model
import Browser.Dom exposing (Error(..))
import Global.Route as Route
import Html
import Html.Attributes


view : Route.Route -> App.Model.Model -> List (Html.Html App.Message.Message)
view page _ =
    [ Html.div [] <|
        case page of
            Route.Root ->
                [ Html.a
                    [ Html.Attributes.href "/gallery"
                    , Html.Attributes.class "go-to-gallery" ]
                    [ Html.text "Go to Gallery" ] ]

            Route.NotFound ->
                [ Html.text <| "404 - Not Found" ]

            Route.SomethingWentWrong ( code, message ) ->
                [ Html.strong [] [ Html.text <| String.fromInt code ]
                , Html.div [] [ Html.text message ]
                ]
    ]
