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


module Projection exposing (project, projectEye, projectSeer)

{-| Do geometric projection.

Types are defined in `Projection.Types`.

@docs project, projectEye, projectSeer

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


{-| Project an Eye to one fewer dimensions.
-}
projectEye : Eye -> Eye
projectEye eye =
    removeEyeDimension 2 eye


{-| Same as `project`, but takes a `Seer` as the second arg.
-}
projectSeer : Point -> Seer -> Point
projectSeer point seer =
    project point seer.eye
