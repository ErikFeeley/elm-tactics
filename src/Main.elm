module Main exposing (..)

import Html exposing (Html, text)
import Navigation exposing (Location)
import Page.Battles as Battles
import Page.Errored as Errored exposing (PageLoadError)
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Task
import Views.Page as Page exposing (ActivePage, frame)


-- MODEL


type Page
    = Blank
    | NotFound
    | Errored PageLoadError
    | Home Home.Model
    | Battles


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState }


init : Location -> ( Model, Cmd Msg )
init location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage }


initialPage : Page
initialPage =
    Blank



-- VIEW


{-|

    can put isLoading back in here for when i want to re-implement the loader stuff

-}
view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage page

        TransitioningFrom page ->
            viewPage page


viewPage : Page -> Html Msg
viewPage page =
    case page of
        Blank ->
            Html.text ""
                |> frame Page.Other

        NotFound ->
            NotFound.view
                |> frame Page.Other

        Errored subModel ->
            Errored.view subModel
                |> frame Page.Other

        Home subModel ->
            Home.view subModel
                |> frame Page.Home
                |> Html.map HomeMsg

        Battles ->
            Battles.view
                |> frame Page.Battles



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ pageSubscriptions (getPage model.pageState) ]


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Errored _ ->
            Sub.none

        Home _ ->
            Sub.none

        Battles ->
            Sub.none



-- UPDATE


type Msg
    = SetRoute (Maybe Route)
    | HomeMsg Home.Msg


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }
            , Task.attempt toMsg task
            )
    in
    case maybeRoute of
        Nothing ->
            ( { model | pageState = Loaded NotFound }, Cmd.none )

        Just Route.Root ->
            ( model, Route.modifyUrl Route.Home )

        Just Route.Home ->
            ( { model | pageState = Loaded (Home Home.init) }, Cmd.none )

        Just Route.Battles ->
            ( { model | pageState = Loaded Battles }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
            ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )
    in
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            setRoute route model

        ( HomeMsg subMsg, Home subModel ) ->
            toPage Home HomeMsg Home.update subMsg subModel

        ( HomeMsg subMsg, _ ) ->
            ( model, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
