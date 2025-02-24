--------------------------------------------------------------------------------
--
-- Util.elm
-- Utilities for `Projection.Types`
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection.Util exposing
    ( numberDimension, pointDimension, vectorDimension
    , shapeDimension, roomDimension, eyeDimension, seerDimension
    , isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid
    )

{-| Utilities for `Project.Types`


# Count Dimension

@docs numberDimension, pointDimension, vectorDimension
@docs shapeDimension, roomDimension, eyeDimension, seerDimension


# Check Validity

@docs isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid

-}

import List.Extra as LE
import Projection.Types
    exposing
        ( Eye
        , Number
        , Point
        , Room
        , Rotation
        , Seer
        , Shape
        , Vector
        )


{-| A number has 0 dimension.
-}
numberDimension : Number -> Int
numberDimension number =
    0


{-| Count the dimensions of a `Point`.
-}
pointDimension : Point -> Int
pointDimension =
    List.length


{-| Count the dimensions of a `Vector`.
-}
vectorDimension : Vector -> Int
vectorDimension =
    .from >> pointDimension


{-| Count the dimensions of a `Shape`.
-}
shapeDimension : Shape -> Int
shapeDimension shape =
    case List.head shape of
        Nothing ->
            0

        Just p ->
            pointDimension p


{-| Count the dimensions of a `Room`.
-}
roomDimension : Room -> Int
roomDimension room =
    case List.head room of
        Nothing ->
            0

        Just shape ->
            shapeDimension shape


{-| Count the dimensions of an `Eye`.
-}
eyeDimension : Eye -> Int
eyeDimension =
    .position >> pointDimension


{-| Count the dimensions of a `Seer`.
-}
seerDimension : Seer -> Int
seerDimension seer =
    seer.body |> roomDimension


{-| A `Vector` is valid if both of its ends have the same number of dimension.
-}
isVectorValid : Vector -> Bool
isVectorValid vector =
    pointDimension vector.from == pointDimension vector.to


{-| A `Shape` is valid if all of its `Point`s are of the same dimension.
-}
isShapeValid : Shape -> Bool
isShapeValid shape =
    List.map pointDimension shape
        |> LE.unique
        |> List.length
        |> (>) 2


{-| A `Room` is valid if all of its `Shape`s are valid and have the same dimension.
-}
isRoomValid : Room -> Bool
isRoomValid room =
    (List.map isShapeValid room
        |> LE.unique
        |> (\x -> x == [] || x == [ True ])
    )
        && (List.map shapeDimension room
                |> LE.unique
                |> List.length
                |> (>) 2
           )


{-| An `Eye` is valid if `eye.direction` is valid and
`eye.direction.from == eye.position`,
And the `eye.direction` is not of zero length.
-}
isEyeValid : Eye -> Bool
isEyeValid eye =
    isVectorValid eye.direction
        && (eye.position == eye.direction.from)
        -- This should probably demand some minimum distance
        && (eye.direction.from /= eye.direction.to)


{-| A `Seer` is valid if both its `eye` and its `body` are valid
and have the same number of dimension.
-}
isSeerValid : Seer -> Bool
isSeerValid seer =
    isRoomValid seer.body
        && isEyeValid seer.eye
        && (roomDimension seer.body == eyeDimension seer.eye)
