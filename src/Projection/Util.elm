-------------------------------------------------------------------------------
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
    ( numberDimension, pointDimension, vectorDimension, matrixDimension
    , shapeDimension, roomDimension, eyeDimension, seerDimension
    , isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid, isMatrixValid
    , pointDistance
    , apply_id, apply0, apply1
    , pplus, pminus, ptimes, pdivide, pdot, papply, papply1
    , removeDimension, removeEyeDimension
    , transformPoint, rotationMatrix
    , timesRoom, timesShape, timesPoint
    , addPointToShape, addPointToRoom
    , allTrue
    )

{-| Utilities for `Project.Types`


# Count Dimension

@docs numberDimension, pointDimension, vectorDimension, matrixDimension
@docs shapeDimension, roomDimension, eyeDimension, seerDimension


# Check Validity

@docs isEyeValid, isRoomValid, isSeerValid, isShapeValid, isVectorValid, isMatrixValid


# `distance`

This IS a metric space, so it has a `distance` function.

Imagine a package for non-metric spaces.

@docs pointDistance


# Apply, Elm Style

@docs apply_id, apply0, apply1


# Point math

@docs pplus, pminus, ptimes, pdivide, pdot, papply, papply1


# Remove a dimension.

@docs removeDimension, removeEyeDimension


# Transform a point.

@docs transformPoint, rotationMatrix


# Other stuff

@docs timesRoom, timesShape, timesPoint
@docs addPointToShape, addPointToRoom
@docs allTrue

-}

import List.Extra as LE
import Projection.Types
    exposing
        ( Eye
        , Matrix
        , Number
        , Point
        , Room
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


{-| Count the dimensions of a `Matrix`.
-}
matrixDimension : Matrix -> Int
matrixDimension matrix =
    case matrix of
        [] ->
            0

        p :: rest ->
            pointDimension p


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
seerDimension =
    .body >> roomDimension


{-| A `Vector` is valid if both of its ends have the same number of dimension.
-}
isVectorValid : Vector -> Bool
isVectorValid vector =
    pointDimension vector.from == pointDimension vector.to


{-| A `Matrix` is valid if all of its rows have the same number of dimensions.
-}
isMatrixValid : Matrix -> Bool
isMatrixValid matrix =
    List.map pointDimension matrix
        |> LE.unique
        |> List.length
        |> (>) 2


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


{-| An `Eye` is valid if `eye.direction` is of the same dimension as
Eye.position, `eye.up` is of the same dimension as eye.direction, and
eye.up is not the origin.
-}
isEyeValid : Eye -> Bool
isEyeValid eye =
    (pointDimension eye.position == pointDimension eye.direction)
        -- This should probably demand some minimum distance
        && (pointDimension eye.position == pointDimension eye.up)
        -- Likewise
        && (eye.up /= List.repeat (pointDimension eye.up) 0)
        && (pointDimension eye.up == pointDimension eye.position)


{-| A `Seer` is valid if both its `eye` and its `body` are valid
and have the same number of dimension.
-}
isSeerValid : Seer -> Bool
isSeerValid seer =
    isRoomValid seer.body
        && (allTrue <| List.map isEyeValid seer.eyes)
        && (let
                dim =
                    roomDimension seer.body
            in
            allTrue <| List.map (\eye -> dim == eyeDimension eye) seer.eyes
           )


{-| True if the list is all `True`.
-}
allTrue : List Bool -> Bool
allTrue bools =
    not <| List.member False bools


{-| I don't think Elm has apply, and I discovered why when I wrote it.
You need an ID function, as a basis for the value, when there are no args.
-}
apply_id : y -> (x -> y -> y) -> List x -> y
apply_id id f xs =
    let
        applyer f2 sum xs2 =
            case xs2 of
                [] ->
                    sum

                x :: tail ->
                    applyer f2
                        (f2 x sum)
                        tail
    in
    applyer f id xs


{-| `apply` for functions with an id of 0.
-}
apply0 : (a -> number -> number) -> List a -> number
apply0 =
    apply_id 0


{-| `apply` for functions with an id of 1.
-}
apply1 : (a -> number -> number) -> List a -> number
apply1 =
    apply_id 1


{-| The distance between two points.

    sqrt ((p1 - p2) ^ 2)

-}
pointDistance : Point -> Point -> Number
pointDistance p1 p2 =
    List.map2 (-) p1 p2
        |> List.map (\x -> x ^ 2)
        |> apply0 (+)
        |> sqrt


{-| Add points
-}
pplus : Point -> Point -> Point
pplus p1 p2 =
    papply (+) p1 p2


{-| Subtract points
-}
pminus : Point -> Point -> Point
pminus p1 p2 =
    papply (-) p1 p2


{-| Multiply points.
-}
ptimes : Point -> Point -> Point
ptimes p1 p2 =
    papply (*) p1 p2


{-| Divide points.
-}
pdivide : Point -> Point -> Point
pdivide p1 p2 =
    papply (/) p1 p2


{-| Dot product.
-}
pdot : Point -> Point -> Number
pdot p1 p2 =
    ptimes p1 p2
        |> apply0 (+)


{-| Apply a function to two points.
-}
papply : (Number -> Number -> Number) -> Point -> Point -> Point
papply f p1 p2 =
    List.map2 f p1 p2


{-| Apply a function to one point.
-}
papply1 : (Number -> Number) -> Point -> Point
papply1 f p =
    List.map f p


cdr : List a -> List a
cdr l =
    case List.tail l of
        Nothing ->
            []

        Just tail ->
            tail


{-| Remove a dimension from a point
-}
removeDimension : Int -> Point -> Point
removeDimension dim p =
    if dim >= pointDimension p then
        p

    else
        let
            loop d tail res =
                if d >= dim then
                    List.reverse res ++ cdr tail

                else
                    case tail of
                        [] ->
                            List.reverse res

                        head :: rest ->
                            loop (d + 1) rest <| head :: res
        in
        loop 0 p []


{-| Remove a dimension from an `Eye`.
-}
removeEyeDimension : Int -> Eye -> Eye
removeEyeDimension dim { position, direction, up } =
    { position = removeDimension dim position
    , direction = removeDimension dim direction
    , up = removeDimension dim up
    }


{-| Multiple a matrix by a point.
-}
transformPoint : Matrix -> Point -> Point
transformPoint matrix point =
    if matrixDimension matrix /= pointDimension point then
        point

    else
        List.map (pdot point) matrix


{-| Distribute times
-}
timesRoom : Number -> Room -> Room
timesRoom n room =
    List.map (timesShape n) room


{-| Distribute times
-}
timesShape : Number -> Shape -> Shape
timesShape n shape =
    List.map (timesPoint n) shape


{-| Distribute times
-}
timesPoint : Number -> Point -> Point
timesPoint n p =
    List.map ((*) n) p


{-| Add a point to all the points in a shape.
-}
addPointToShape : Point -> Shape -> Shape
addPointToShape p s =
    List.map (pplus p) s


{-| Add a point to all the points in a room.
-}
addPointToRoom : Point -> Room -> Room
addPointToRoom p r =
    List.map (addPointToShape p) r


{-| The matrix to rotate an n-dimensional scene by an angle θ
around a central line, assuming the line is along the nth axis
and the rotation occurs in the x-y plane.
-}
rotationMatrix : Int -> Number -> Matrix
rotationMatrix dimension angle =
    let
        nzeroes : Int -> Point
        nzeroes n =
            List.repeat n 0

        oneAt : Int -> Point
        oneAt n =
            nzeroes (n - 1) ++ [ 1 ] ++ nzeroes (dimension - n)

        restOfMatrix : Int -> List Point -> List Point
        restOfMatrix n res =
            if n >= dimension then
                List.reverse res

            else
                restOfMatrix (n + 1) (oneAt n :: res)
    in
    [ [ cos angle, negate (sin angle) ] ++ nzeroes (dimension - 2)
    , [ sin angle, cos angle ] ++ nzeroes (dimension - 2)
    ]
        ++ restOfMatrix 2 []
