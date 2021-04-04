module Page.Gallery.View exposing (view)

import App.Message
import App.Model
import Html
import Html.Attributes
import Page.Gallery.Route
import Page.Gallery.Model
import Page.Gallery.Request exposing (objectsOnPath)
import Html exposing (object)


view : Page.Gallery.Route.Route -> App.Model.Model -> List (Html.Html App.Message.Message)
view _ model =
    let
        pfx = prefixPath model.gallery.path
        objects = Maybe.withDefault [] model.gallery.objectList
        folders = List.sortBy sort <| List.filter (filterType "folder") objects
        files = List.sortBy sort <| List.filter (filterType "file") objects
    in
    [ Html.div [ Html.Attributes.class "breadcrumb" ] [ Html.text model.gallery.path ]
    , Html.div [ Html.Attributes.class "folder-list" ]
        <| List.map viewFolder folders
    , Html.div [ Html.Attributes.class "file-list" ]
        <| List.map viewFile files
    ]

viewFolder : Page.Gallery.Model.Object -> Html.Html App.Message.Message
viewFolder folder =
    let
        name = basename folder
    in
    Html.div [ Html.Attributes.class "folder" ]
        [ Html.a [Html.Attributes.href <| "/gallery/show?path=/" ++ folder.key ]
            [ Html.text name ]
        ]

viewFile : Page.Gallery.Model.Object -> Html.Html App.Message.Message
viewFile file =
    let
        name = basename file
    in
    Html.div [ Html.Attributes.class "file" ]
        [ Html.img
            [ Html.Attributes.src <| "/api/get/" ++ file.key
            , Html.Attributes.alt name
            ] []
        , Html.text name
        ]

sort : Page.Gallery.Model.Object -> String
sort object = object.key

filterType : String -> Page.Gallery.Model.Object -> Bool
filterType type_ object = object.type_ == type_

prefixPath : String -> String -> String
prefixPath prefix path =
    let
        p = if String.endsWith "/" prefix then prefix else prefix ++ "/"
    in
        "/gallery/show?path=" ++ p ++ path

basename : Page.Gallery.Model.Object -> String
basename object =
    case object.type_ of
       "folder" -> (Maybe.withDefault "" << List.head << List.drop 1 << List.reverse << String.split "/") object.key ++ "/"
       "file" -> (Maybe.withDefault "" << List.head<< List.reverse << String.split "/") object.key
       _ -> ""