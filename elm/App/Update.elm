module App.Update exposing (..)

import App.Message as Message
import App.Model as Model
import App.Route
import Global.Update
import Page.Gallery.Update
import Page.SignIn.Update


update : Message.Message -> Model.Model -> ( Model.Model, Cmd Message.Message )
update msg model =
    let
        ( globalModel, globalCmd ) =
            Global.Update.update msg model.global

        ( galleryModel, galleryCmd ) =
            Page.Gallery.Update.update msg model model.gallery

        ( signInModel, newToken, signInCmd ) =
            Page.SignIn.Update.update msg model model.signIn

        jwt =
            case newToken of
                Just token ->
                    Just token

                _ ->
                    model.global.jwtToken

        finalModel =
            { model
                | global = { globalModel | jwtToken = jwt }
                , signIn = signInModel
                , gallery = galleryModel
            }

        command = App.Route.redirectCommand finalModel.global.page finalModel.global.navigationKey finalModel.global.jwtToken
        finalCmds =
            Cmd.batch [ command, globalCmd, galleryCmd, signInCmd ]
    in
    ( finalModel, finalCmds )
