module Global.Update exposing (..)

import App.Message as Base
import App.Router
import Browser
import Browser.Navigation as Navigation
import Global.Message as Message
import Global.Model
import Url


update : Base.Message -> Global.Model.Model -> ( Global.Model.Model, Cmd Base.Message )
update msg model =
    case msg of
        Base.Global scopedMsg ->
            case scopedMsg of
                Message.NavigateTo url ->
                    ( model, Navigation.pushUrl model.navigationKey url )

                Message.UrlChanged url ->
                    update Base.NoOp { model | page = App.Router.parsedUrl url }

                Message.UrlRequest request ->
                    case request of
                        Browser.Internal url ->
                            ( model, Navigation.pushUrl model.navigationKey (Url.toString url) )

                        Browser.External url ->
                            ( model, Navigation.load url )

        _ ->
            ( model, Cmd.none )
