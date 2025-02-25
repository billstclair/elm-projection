--------------------------------------------------------------------------------
--
-- EncodeDecode.elm
-- Json encoders and decoders for `Projection.Types`
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection.EncodeDecode exposing
    ( encodeNumber, encodePoint, encodeVector
    , encodeShape, encodeRoom, encodeEye, encodeSeer
    , numberDecoder, pointDecoder, vectorDecoder
    , shapeDecoder, roomDecoder, eyeDecoder, seerDecoder
    )

{-| Json encoders and decoders for `Projection.Types`


# Encoders

@docs encodeNumber, encodePoint, encodeVector
@docs encodeShape, encodeRoom, encodeEye, encodeSeer


# Decoders

@docs numberDecoder, pointDecoder, vectorDecoder
@docs shapeDecoder, roomDecoder, eyeDecoder, seerDecoder

-}

import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as DP exposing (custom, hardcoded, optional, required)
import Json.Encode as JE exposing (Value)
import Projection.Types exposing (Eye, Number, Point, Room, Seer, Shape, Vector)


{-| Encode a `Number`
-}
encodeNumber : Number -> Value
encodeNumber number =
    JE.float number


{-| `Decoder` for `Number`s
-}
numberDecoder : Decoder Number
numberDecoder =
    JD.float


{-| Encode a `Point`
-}
encodePoint : Point -> Value
encodePoint point =
    JE.list encodeNumber point


{-| Decoder for `Point`s.
-}
pointDecoder : Decoder Point
pointDecoder =
    JD.list numberDecoder


{-| Encode a `Vector`
-}
encodeVector : Vector -> Value
encodeVector vector =
    JE.object
        [ ( "from", encodePoint vector.from )
        , ( "to", encodePoint vector.to )
        ]


{-| Decoder for `Vector`s.
-}
vectorDecoder : Decoder Vector
vectorDecoder =
    JD.succeed Vector
        |> required "from" pointDecoder
        |> required "to" pointDecoder


{-| Encode a `Shape`.
-}
encodeShape : Shape -> Value
encodeShape shape =
    JE.list encodePoint shape


{-| Decoder for `Shape`s.
-}
shapeDecoder : Decoder Shape
shapeDecoder =
    JD.list pointDecoder


{-| Encode a `Room`.
-}
encodeRoom : Room -> Value
encodeRoom room =
    JE.list encodeShape room


{-| Decoder for `Room`s.
-}
roomDecoder : Decoder Room
roomDecoder =
    JD.list shapeDecoder


{-| Encode an `Eye`
-}
encodeEye : Eye -> Value
encodeEye eye =
    JE.object
        [ ( "position", encodePoint eye.position )
        , ( "direction", encodeVector eye.direction )
        , ( "up", encodeVector eye.up )
        ]


{-| Decoder for `Eye`s.
-}
eyeDecoder : Decoder Eye
eyeDecoder =
    JD.succeed Eye
        |> required "position" pointDecoder
        |> required "direction" vectorDecoder
        |> required "up" vectorDecoder


{-| Encode a `Seer`
-}
encodeSeer : Seer -> Value
encodeSeer seer =
    JE.object
        [ ( "body", encodeRoom seer.body )
        , ( "eye", encodeEye seer.eye )
        ]


{-| Decoder for `Seer`s.
-}
seerDecoder : Decoder Seer
seerDecoder =
    JD.succeed Seer
        |> required "body" roomDecoder
        |> required "eye" eyeDecoder
