module App.Update exposing (..)

import App.Message as Message
import App.Model as Model
import Global.Update
import Page.SignIn.Update


update : Message.Message -> Model.Model -> ( Model.Model, Cmd Message.Message )
update msg model =
    let
        ( globalModel, globalCmd ) =
            Global.Update.update msg model.global

        -- ( mainPageModel, mainPageCmd ) =
        --     Page.Main.Update.update msg model.mainPage

        ( signInModel, signInCmd ) =
            Page.SignIn.Update.update msg model model.signIn

        finalModel =
            { model
                | global = globalModel
                -- , mainPage = mainPageModel
                , signIn = signInModel
            }

        finalCmds =
            Cmd.batch [ globalCmd, signInCmd ]
    in
    ( finalModel, finalCmds )