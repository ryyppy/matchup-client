module Activity exposing (..)

import Util exposing (paddedNumber)
import String
import Html exposing (Html, button, div, text, table, tr, td, h2)
import Html.App as App
import Html.Events exposing (onClick)

-- MODEL

type alias Participant = 
  { shortname: String
  , email: Maybe String
  }

type alias Activity =
  { name: String
  , creator: String
  , participants: List Participant
  , maxParticipants: Int
  , status: Status
  , timeLeft: Int -- seconds
  }

type alias Model = List Activity

init: Model
init =
  List.repeat 2 myActivity 

-- UPDATE

type Status = 
  Pending
  | GettingReady
  | Playing
  | NextUp

myActivity: Activity
myActivity = 
  { name = "#Soccer"
 , creator = "FOO"
 , participants = List.repeat 3 myParticipant
 , maxParticipants = 4
 , status = GettingReady
 , timeLeft = 5
 }

myParticipant: Participant
myParticipant =
  { shortname = "LOA"
  , email = Just "lorenzo@runtastic.com"
  }

type Msg =
  Join

update: Msg -> Model -> Participant -> Model
update msg model currentUser =
  case msg of
    Join ->
      model

-- VIEW

signupButton: Html Msg
signupButton = button [ onClick Join ] [ text "Join" ]

participantsLeft: Activity -> Int
participantsLeft activity =
  activity.maxParticipants - (List.length activity.participants)

renderTime: Int -> String
renderTime seconds =
  let
      leftover = 0
      hours = round((toFloat seconds) / 3600)
      minuteBase = seconds % 3600
      minutes = round((toFloat minuteBase) / 60)
      secondsRest = minuteBase % 60
  in
     (paddedNumber hours) ++ ":" ++ (paddedNumber minutes) ++ ":" ++ (paddedNumber secondsRest)

renderTeam: List Participant -> String
renderTeam participants =
  String.join ", " (List.map (\p -> p.shortname) participants)

renderActivity: Participant -> Activity -> Html Msg
renderActivity currentUser activity =
  let
      left = participantsLeft activity
      button = if (activity.creator /= currentUser.shortname && left > 0) 
                  then 
                    [signupButton] 
                  else 
                    []
  in

  tr []
  [ td [] [ text activity.name ]
  , td [] [ text (renderTeam activity.participants) ]
  , td [] [ text (toString (participantsLeft activity)) ]
  , td [] [ text (renderTime activity.timeLeft) ]
  , td [] button 
  ]

renderActivityTable: Model -> Participant -> Html Msg
renderActivityTable model currentUser =
  table []
  (List.map (renderActivity currentUser) model)

view: Model -> Participant -> Html Msg
view model currentUser =
  let
      activity_count = List.length model
  in
     div []
     [ h2 [] [ text "Activities" ] 
     , (renderActivityTable model currentUser) ]
     
