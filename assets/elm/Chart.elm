module Chart
    exposing
        ( Chart
        , mkChart
        , mkLineChart
        , createChart
        , ProtoSeries
        )

import Array exposing (Array)
import Color exposing (Color, rgb)
import Color.Convert exposing (colorToHex)
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes exposing (property, class)
import Json.Encode exposing (..)
import Native.Chart
import Time exposing (Time)


infixr 0 =>
(=>) : a -> b -> ( a, b )
(=>) =
    (,)


type alias DataPoint =
    ( Time, Float )


type alias Series =
    { id : String
    , name : String
    , color : Color
    , data : Array DataPoint
    }

type alias ProtoSeries =
    { name : String
    , data : Array DataPoint
    }


type alias Chart =
    { chartType : String
    , title : String
    , series : List Series
    }



chartColors : Array Color
chartColors =
  Array.fromList
    [ (rgb 0 255 0)
    , (rgb 255 0 0)
    , (rgb 0 0 255)
    , (rgb 100 100 0)
    , (rgb 0 100 100)
    ]

getChartColorWithDefault : Int -> Array Color -> Color
getChartColorWithDefault index colors =
  case Array.get index colors of
    Just color -> color
    Nothing -> rgb 0 0 255


mkLineChart : String -> List ProtoSeries -> Chart
mkLineChart title protoSeries =
  mkChart "line" title protoSeries

mkChart : String -> String -> List ProtoSeries -> Chart
mkChart chartType title protoSeries =
    let
      series = List.indexedMap (,) protoSeries
      |> List.map (\(i, ps) -> Series (toString i) ps.name (getChartColorWithDefault i chartColors) ps.data )
    in
        Chart chartType title series



chartToJson : Chart -> Value
chartToJson c =
    let
        seriesToJson : Series -> Value
        seriesToJson s =
            object
                [ "id" => string s.id
                , "name" => string s.name
                -- , "color" => string (colorToHex s.color)
                , "data" => array (Array.map (\( t, n ) -> list [ float t, float n ]) s.data)
                ]

        series =
            list (List.map seriesToJson c.series)
    in
        object
            [ "chartType" => string c.chartType
            , "title" => string c.title
            , "series" => series
            ]


data : Value -> Attribute msg
data =
    property "data"


createChart : Chart -> Html msg
createChart c =
    Native.Chart.toHtml [ data (chartToJson c) ] []
