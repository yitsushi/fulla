module Page.Gallery.View exposing (view)

import App.Message
import App.Model
import Html exposing (object)
import Html.Attributes
import Html.Events
import Page.Gallery.Message
import Page.Gallery.Model
import Page.Gallery.Route


view : Page.Gallery.Route.Route -> App.Model.Model -> List (Html.Html App.Message.Message)
view _ model =
    let
        objects =
            Maybe.withDefault [] model.gallery.objectList

        folders =
            List.sortBy sort <| List.filter (filterType "folder") objects

        files =
            List.sortBy sort <| List.filter (\f -> String.startsWith "image" f.mime) <| List.filter (filterType "file") objects
    in
    [ Html.div [ Html.Attributes.class "breadcrumb" ] <| bcToLink (Breadcrumb "root" "/") :: breadcrumb model.gallery.path
    , Html.div [ Html.Attributes.class "folder-list" ] <|
        List.map viewFolder folders
    , Html.div [ Html.Attributes.class "file-list" ] <|
        List.map viewFile files
    , case model.gallery.enlarge of
        Just path ->
            enlargePopup path

        Nothing ->
            Html.div [] []
    ]


breadcrumb : String -> List (Html.Html App.Message.Message)
breadcrumb path =
    List.map bcToLink <| listToBreadcrumb <| List.filter (not << String.isEmpty) <| String.split "/" path


type Breadcrumb
    = Breadcrumb String String


bcTarget : Breadcrumb -> String
bcTarget (Breadcrumb _ target) =
    target


bcToLink : Breadcrumb -> Html.Html App.Message.Message
bcToLink (Breadcrumb str target) =
    Html.a [ Html.Attributes.href <| "/gallery/show?path=" ++ target ] [ Html.text str ]


listToBreadcrumb : List String -> List Breadcrumb
listToBreadcrumb path =
    let
        f : String -> List Breadcrumb -> List Breadcrumb
        f item carry =
            carry ++ [ Breadcrumb item <| (bcTarget << Maybe.withDefault (Breadcrumb "" "") << List.head << List.reverse) carry ++ "/" ++ item ]
    in
    List.foldl f [] path


viewFolder : Page.Gallery.Model.Object -> Html.Html App.Message.Message
viewFolder folder =
    let
        name =
            basename folder
    in
    Html.a
        [ Html.Attributes.href <| "/gallery/show?path=/" ++ folder.key
        , Html.Attributes.class "folder"
        ]
        [ Html.text name ]


viewFile : Page.Gallery.Model.Object -> Html.Html App.Message.Message
viewFile file =
    let
        name =
            basename file
    in
    Html.div [ Html.Attributes.class "file" ]
        [ Html.img
            [ Html.Attributes.src <| "/api/get/" ++ file.key
            , Html.Attributes.alt name
            , Html.Events.onClick <| gEvent <| Page.Gallery.Message.Enlarge file.key
            ]
            []
        , Html.text name
        ]


gEvent : Page.Gallery.Message.Message -> App.Message.Message
gEvent msg =
    App.Message.Gallery msg


sort : Page.Gallery.Model.Object -> String
sort object =
    object.key


filterType : String -> Page.Gallery.Model.Object -> Bool
filterType type_ object =
    object.type_ == type_


basename : Page.Gallery.Model.Object -> String
basename object =
    case object.type_ of
        "folder" ->
            (Maybe.withDefault "" << List.head << List.drop 1 << List.reverse << String.split "/") object.key ++ "/"

        "file" ->
            (Maybe.withDefault "" << List.head << List.reverse << String.split "/") object.key

        _ ->
            ""


enlargePopup : String -> Html.Html App.Message.Message
enlargePopup path =
    Html.div
        [ Html.Attributes.class "enlarge-popup" ]
        [ Html.span
            [ Html.Events.onClick <| gEvent <| Page.Gallery.Message.Shrink ]
            [ Html.img [ Html.Attributes.src "/static/x.png" ] [] ]
        , Html.img [ Html.Attributes.src <| "/api/get/" ++ path ] []
        ]
