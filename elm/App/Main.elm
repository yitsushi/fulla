module App.Main exposing (..)

import App.Flags exposing (Flags)
import App.Init exposing (init)
import App.Message exposing (Message)
import App.Model exposing (Model)
import App.Router exposing (onUrlChange, onUrlRequest)
import App.Update exposing (update)
import App.View exposing (view)
import App.Sub exposing (subscriptions)
import Browser

main : Program Flags Model Message
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }