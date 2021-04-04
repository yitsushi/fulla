module Page.Gallery.Model exposing (..)

import Array


type alias Model =
    { objectList : Maybe (List Object)
    , path : String
    , error : Maybe String
    , enlarge : Maybe String
    }


type alias Object =
    { key : String
    , type_ : String
    , mime : String
    }


initialModel : Maybe String -> Model
initialModel path =
    { objectList = Nothing
    , path = Maybe.withDefault "/" path
    , error = Nothing
    , enlarge = Nothing
    }


nextImage : List Object -> Bool -> String -> Maybe String
nextImage objects firstMatch path =
    if firstMatch
    then
        case objects of
            first::_ -> Just first.key
            _ -> Nothing
    else
        case objects of
            [] ->
                Nothing

            first :: [] ->
                if first.key == path then
                    Nothing

                else
                    Nothing

            first :: rest ->
                if first.key == path then
                    nextImage rest True path

                else
                    nextImage rest firstMatch path
