module Matchup exposing (..)

import Activity exposing (..)

import Html exposing (Html, button, div, text, h1)
import Html.App as App
import Html.Events exposing (onClick)


-- MODEL

type alias Model = 
  { activities: Activity.Model
  , currentUser: Activity.Participant
  }


model: Model
model =
  {
    activities = Activity.init 
    , currentUser = Activity.myParticipant 
  }

-- UPDATE

type Msg
  = Foo Activity.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    Foo activityMessage ->
      {model | activities = Activity.update activityMessage model.activities model.currentUser}
  
-- VIEW

view : Model -> Html Msg
view model =
  div []
  [
   h1 [] [ text "Runtastic Matchup :-)" ]
  , div [] [ App.map Foo (Activity.view model.activities model.currentUser) ]
  ]

main =
  App.beginnerProgram
  { model = model
  , view = view
  , update = update
  }
