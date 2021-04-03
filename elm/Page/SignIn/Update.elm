module Page.SignIn.Update exposing (..)

import App.Message as Base
import App.Model
import App.Port
import Browser.Navigation as Navigation
import Http
import Json.Decode exposing (Decoder)
import Json.Encode as Encode
import Page.SignIn.Message as Msg
import Page.SignIn.Model exposing (Model, initialModel)
import Page.SignIn.Token exposing (Token(..))


update : Base.Message -> App.Model.Model -> Model -> ( Model, Maybe String, Cmd Base.Message )
update msg global model =
    case msg of
        Base.SignIn (Msg.NameInput value) ->
            ( { model | name = value }, Nothing, Cmd.none )

        Base.SignIn (Msg.TokenInput value) ->
            ( { model | token = value }, Nothing, Cmd.none )

        Base.SignIn Msg.SubmitForm ->
            ( initialModel, Nothing, sendLoginForm model <| wrapMsg Msg.LoginResponse )

        Base.SignIn (Msg.LoginResponse response) ->
            case response of
                Ok (Token token "") ->
                    ( model, Just token, Cmd.batch [ App.Port.saveToken token, Navigation.pushUrl global.global.navigationKey "/" ] )

                _ ->
                    ( { model | error = True }, Nothing, Cmd.none )

        _ ->
            ( model, Nothing, Cmd.none )


wrapMsg : (Result Http.Error Token -> Msg.Message) -> Result Http.Error Token -> Base.Message
wrapMsg msg param =
    Base.SignIn <| msg param


sendLoginForm : Model -> (Result Http.Error Token -> a) -> Cmd a
sendLoginForm model msg =
    Http.post
        { url = "/api/login"
        , body = Http.jsonBody <| loginEncoder model
        , expect = Http.expectJson msg loginDecoder
        }


loginDecoder : Decoder Token
loginDecoder =
    Json.Decode.map2 Token (Json.Decode.field "Token" Json.Decode.string) (Json.Decode.field "Error" Json.Decode.string)


loginEncoder : Model -> Encode.Value
loginEncoder model =
    Encode.object
        [ ( "Token", Encode.string model.token )
        , ( "Username", Encode.string model.name )
        ]
