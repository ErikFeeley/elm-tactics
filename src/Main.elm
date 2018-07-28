module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Navigation
import Page.Battles as Battles
import Page.Home as Home
import Route exposing (Route, route)
import UrlParser as Url


type alias Model =
    { page : Maybe Route }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model (Just Route.Home), Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Links" ]
        , ul [] (List.map viewLink [ "/", "/battles" ])
        , viewPage model.page
        ]


viewPage : Maybe Route -> Html Msg
viewPage page =
    case page of
        Just Route.Home ->
            Home.view Home.initialModel

        Just Route.Battles ->
            Battles.view

        Nothing ->
            h1 [] [ text "not found" ]


viewLink : String -> Html Msg
viewLink url =
    li [] [ button [ onClick (NewUrl url) ] [ text url ] ]


type Msg
    = NewUrl String
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model, Navigation.newUrl url )

        UrlChange location ->
            ( { model | page = Url.parsePath route location }, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
