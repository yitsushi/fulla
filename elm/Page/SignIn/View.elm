module Page.SignIn.View exposing (view)

import App.Message
import App.Model
import Html
import Html.Attributes
import Html.Events
import Page.SignIn.Message
import Page.SignIn.Route


onInputHandler : (String -> Page.SignIn.Message.Message) -> String -> App.Message.Message
onInputHandler msg str =
    App.Message.SignIn <| msg str


view : Page.SignIn.Route.Route -> App.Model.Model -> List (Html.Html App.Message.Message)
view _ model =
    [ Html.div [ Html.Attributes.class "signin-box" ]
        [ Html.input
            [ Html.Attributes.placeholder "What's your name?"
            , Html.Attributes.value model.signIn.name
            , Html.Events.onInput <| onInputHandler Page.SignIn.Message.NameInput
            ]
            []
        , Html.input
            [ Html.Attributes.type_ "password"
            , Html.Attributes.placeholder "SignIn with your secret token"
            , Html.Attributes.value model.signIn.token
            , Html.Events.onInput <| onInputHandler Page.SignIn.Message.TokenInput
            ]
            []
        , Html.button
            [ Html.Events.onClick <| App.Message.SignIn Page.SignIn.Message.SubmitForm ]
            [ Html.text "Submit" ]
        ]
    , if model.signIn.error then
        Html.img [ Html.Attributes.src "/static/nope.png", Html.Attributes.class "nope" ] []

      else
        Html.div [] []
    ]
