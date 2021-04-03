module Page.Gallery.View exposing (view)

import App.Message
import App.Model
import Html
import Html.Attributes
import Page.Gallery.Route


view : Page.Gallery.Route.Route -> App.Model.Model -> List (Html.Html App.Message.Message)
view _ model =
    [ Html.div [ Html.Attributes.class "breadcrumb" ] [ Html.text model.gallery.path ]
    , Html.div [ Html.Attributes.class "file-list" ] [ Html.text "---" ]
    ]
