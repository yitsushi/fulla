module Page.Gallery.Request exposing (..)

import App.Message as Base
import Http
import Json.Decode exposing (Decoder)
import Page.Gallery.Message as Msg
import Page.Gallery.Model exposing (Model)


wrapMsg : (Result Http.Error (List Page.Gallery.Model.Object) -> Msg.Message) -> Result Http.Error (List Page.Gallery.Model.Object) -> Base.Message
wrapMsg msg param =
    Base.Gallery <| msg param


objectsOnPath : Maybe String -> Model -> (Result Http.Error (List Page.Gallery.Model.Object) -> a) -> Cmd a
objectsOnPath jwt model msg =
    let
        _ = Debug.log "JWT for the request" jwt
        _ = Debug.log "model" model
    in
    case jwt of
        Nothing ->
            Cmd.none

        Just _ ->
            Http.request
                { url = "/api/list" ++ model.path
                , expect = Http.expectJson msg objectListDecoder
                , method = "GET"
                , body = Http.emptyBody
                , timeout = Nothing
                , tracker = Nothing
                , headers =
                    [ Http.header "JWT-TOKEN" <| Maybe.withDefault "" jwt
                    ]
                }


objectDecoder : Decoder Page.Gallery.Model.Object
objectDecoder =
    Json.Decode.map2
        Page.Gallery.Model.Object
        (Json.Decode.field "Key" Json.Decode.string)
        (Json.Decode.field "Type" Json.Decode.string)


objectListDecoder : Decoder (List Page.Gallery.Model.Object)
objectListDecoder =
    Json.Decode.list objectDecoder
