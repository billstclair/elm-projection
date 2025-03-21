----------------------------------------------------------------------
--
-- Projection.elm
-- Do projection.
-- projection point eye = (newPoint, newEye)
-- newPoint & newEye have one fewer dimensions than point & eye.
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection exposing
    ( project, projectEye, projectPointAndEye, projectSeer
    , projectTo2D, projectShapeTo2D
    )

{-| Do geometric projection.

Types are defined in `Projection.Types`.

@docs project, projectEye, projectPointAndEye, projectSeer
@docs projectTo2D, projectShapeTo2D

-}

import Projection.Types as Types exposing (Eye, Point, Room, Seer, Shape, Vector)
import Projection.Util as Util
    exposing
        ( eyeDimension
        , papply
        , papply1
        , pdivide
        , pdot
        , pminus
        , pointDimension
        , pplus
        , ptimes
        , removeDimension
        , removeEyeDimension
        )


{-| Project a point to one fewer dimensions.
-}
project : Point -> Eye -> Point
project point eye =
    let
        dim =
            pointDimension point

        eyeDim =
            eyeDimension eye

        dimsOk =
            dim == eyeDim

        dims =
            ( dim, eyeDim )

        msg =
            if dimsOk then
                dims

            else
                Debug.log "Projection.project, dims don't match." dims

        { position, direction, up } =
            eye

        positionOk =
            removeDimension 1 position == [ 0, 0 ]

        directionOk =
            direction == List.repeat dim 0

        upOk =
            up == [ 0, 1, 0 ]

        eye2 =
            if positionOk && directionOk && upOk then
                eye

            else
                Debug.log "  Eye not OK" eye

        ( l, e ) =
            ( List.repeat dim 0, position )

        p =
            point

        -- (L-E)•(P-E) / (L-E)•(L-E)
        lE_PEoverLE_LE =
            pminus l e
                |> pdot (pminus p e)
                |> (/)
                    (pminus l e
                        |> pdot (pminus l e)
                    )

        q =
            pplus e <|
                papply1 ((*) lE_PEoverLE_LE) (pminus p e)
    in
    -- This works only if eye is on the y axis and up is on the z axis.
    removeDimension 2 q


{-| Project a point and eye to 2 dimensions.
-}
projectTo2D : Point -> Eye -> Point
projectTo2D point eye =
    if Util.pointDimension point <= 2 then
        point

    else
        let
            ( p2, e2 ) =
                projectPointAndEye point eye
        in
        projectTo2D p2 e2


{-| Project a `Shape` to 2 dimensions.
-}
projectShapeTo2D : Shape -> Eye -> Shape
projectShapeTo2D shape eye =
    let
        projectOne : Point -> Point
        projectOne point =
            projectTo2D point eye
    in
    List.map projectOne shape


{-| Project an Eye to one fewer dimensions.
-}
projectEye : Eye -> Eye
projectEye eye =
    removeEyeDimension 2 eye


{-| Project a point and the eye to one fewer dimensions.
-}
projectPointAndEye : Point -> Eye -> ( Point, Eye )
projectPointAndEye point eye =
    ( project point eye, projectEye eye )


{-| Same as `project`, but takes a `Seer` as the second arg.
-}
projectSeer : Point -> Seer -> List Point
projectSeer point seer =
    List.map (project point) seer.eyes
