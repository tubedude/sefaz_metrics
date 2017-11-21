module Main exposing (..)

import Html exposing(Html, text, div, a)
import Html.Attributes exposing(href, class)
import Html.Events exposing (onClick)

import Http

import Chart exposing (mkLineChart, ProtoSeries, Chart, createChart)
import Time exposing (Time, hour, every)
import Date exposing (Month(..), fromString, Date, toTime)
import Date.Extra as Date

import Array exposing (fromList)

import RemoteData exposing (WebData, RemoteData)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


init : (Model, Cmd Msg)
init =
  (RemoteData.NotAsked , fetchFacts)


-- MODEL

type alias Model =
  WebData (List Fact)

type alias Fact =
  { date: String
  , nfeQuant: Float
  , emitterQuant: Float}

type FactType
  = Nfe
  | Emitter


-- DECODER

factsDecoder : Decode.Decoder (List Fact)
factsDecoder =
  Decode.at ["data"] (Decode.list factDecoder)


factDecoder : Decode.Decoder Fact
factDecoder =
  decode Fact
    |> required "date" Decode.string
    |> required "nfe_quant" Decode.float
    |> required "emitter_quant" Decode.float



-- MSG
type Msg =
  OnFetchFacts Model
  | FetchFacts
  | Tick Time


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  every hour Tick


-- COMMANDS

fetchFacts : Cmd Msg
fetchFacts =
  Http.get "/api/facts" factsDecoder
  |> RemoteData.sendRequest
  |> Cmd.map OnFetchFacts


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnFetchFacts response ->
      ( response, Cmd.none )

    FetchFacts ->
      ( RemoteData.Loading, fetchFacts)

    Tick _ ->
      ( model, fetchFacts)



-- VIEW

view : Model -> Html Msg
view model =
  div [class "row"]
  [ div [class "chart col-xs-12"] [ displayGen model displayChart  ]
  -- , div [class "chart col-xs-12"] [ displayGen model displayDiff ]
  , div [class "chart col-xs-12"] [ displayGen model displayDelta ]
  , Html.iframe
    [Html.Attributes.src "https://exploratory.io/viz/3828361826296546/4251968259506836?embed=true"
    , Html.Attributes.width 800
    , Html.Attributes.height 600
    , frameborder 0
    ] []
  , viewExtras
  ]

frameborder : Int -> Html.Attribute msg
frameborder borderSize =
  Html.Attributes.attribute "frameborder" (toString borderSize)


-- widthString : String -> Html.Attribute msg
-- widthString sizeString =
--   Html.Attributes.attribute "width" sizeString
--
-- heightString : String -> Html.Attribute msg
-- heightString sizeString =
--   Html.Attributes.attribute "height" sizeString


displayGen : Model -> ((List Fact) -> Html Msg) -> Html Msg
displayGen model f =
  case model of
    RemoteData.NotAsked ->
      text "Did not ask"

    RemoteData.Loading ->
      text "Loading"

    RemoteData.Failure error ->
      displayError error

    RemoteData.Success facts ->
      f facts


displayError : Http.Error -> Html Msg
displayError error =
  case error of
    Http.BadUrl string ->
      text ("Bad URL " ++ string)

    Http.Timeout ->
      text "Timeout"

    Http.NetworkError ->
      text "NetworkError"

    Http.BadStatus msg ->
      text "Bad Status"

    Http.BadPayload string _ ->
      text ("Bad Payload: " ++ string)


displayDelta : List Fact -> Html Msg
displayDelta facts =
  let
    others = case List.tail facts of
      Just remFacts ->
        remFacts

      Nothing ->
        []

    deltaFacts = convertDelta facts others

  in
    createChart ( mkLineChart "NF-e Delta" [convert deltaFacts Nfe] )



convertDelta : List Fact -> List Fact -> List Fact
convertDelta facts others =
  List.map2 (\ a b -> Fact b.date (b.nfeQuant - a.nfeQuant) (b.emitterQuant - a.emitterQuant)) facts others


displayDiff : (List Fact) -> Html Msg
displayDiff facts =
  let
    firstFact = case List.head facts of
      Just fact ->
        fact

      Nothing ->
        Fact "2017-11-17" 0 0

    diffFacts =
      facts
      |> List.map (convertDiff firstFact)
  in
    createChart (mkLineChart "NF-e Diff" (makeSeries diffFacts))

convertDiff : Fact -> Fact -> Fact
convertDiff firstFact fact =
  Fact fact.date (fact.nfeQuant - firstFact.nfeQuant) (fact.emitterQuant - firstFact.emitterQuant)

displayChart : (List Fact) -> Html Msg
displayChart facts =
  createChart (mkLineChart "Brazilian NF-e statistics" (makeSeries facts))


makeSeries : List Fact -> List ProtoSeries
makeSeries facts =
  [Nfe, Emitter]
  |> List.map (convert facts)


convert : List Fact -> FactType ->  ProtoSeries
convert facts factType =
  let
    array = facts
    |> List.map ( makeProtoSeries factType )
    |> Array.fromList
  in
    ProtoSeries (toString factType) array


makeProtoSeries : FactType -> Fact -> (Time, Float)
makeProtoSeries factType fact =
  let
    value = case factType of
      Nfe ->
        fact.nfeQuant

      Emitter ->
        fact.emitterQuant

    date =
      fact.date
      |> Date.fromString
      |> Result.withDefault (Date.fromTime 0)
      |> Date.toTime

  in
    (date, value)


viewExtras  =
  div []
  [
    a
    [ href "/api/facts"
    , class "btn btn-default"
    ]
    [ text "Get Json"]
    ]
