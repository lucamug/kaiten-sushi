# Notes about elm-animator

# Definitions

## Getting started

* type alias Timeline state = Timeline state
* init : state -> Timeline state

## Reading the timeline

* current : Timeline state -> state
* previous : Timeline state -> state

## Wiring up the animation

* type alias Animator model = Animator model
* animator : Animator model
* watching : (model -> Timeline state) -> (Timeline state -> model -> model) -> Animator model -> Animator model
* watchingWith : (model -> Timeline state) -> (Timeline state -> model -> model) -> (state -> Bool) -> Animator model -> Animator model
* toSubscription : (Posix -> msg) -> model -> Animator model -> Sub msg
* update : Posix -> Animator model -> model -> model

## Transitioning to a new state

* go : Duration -> state -> Timeline state -> Timeline state
* type alias Duration = Duration
* immediately : Duration
* veryQuickly : Duration
* quickly : Duration
* slowly : Duration
* verySlowly : Duration
* millis : Float -> Duration
* seconds : Float -> Duration

## Interruptions and Queueing

* type Step state
* wait : Duration -> Step state
* event : Duration -> state -> Step state
* interrupt : List (Step state) -> Timeline state -> Timeline state
* queue : List (Step state) -> Timeline state -> Timeline state

## Animating

* color : Timeline state -> (state -> Color) -> Color
* type alias Movement = DefaultableMovement
* at : Float -> Movement
* move : Timeline state -> (state -> Movement) -> Float
* xy : Timeline state -> ( state -> { x : Movement , y : Movement } ) -> { x : Float , y : Float }
* xyz : Timeline state -> ( state -> { x : Movement , y : Movement , z : Movement } ) -> { x : Float , y : Float , z : Float }
* linear : Timeline state -> (state -> Movement) -> Float

## Transition personality

* leaveLate : Float -> Movement -> Movement
* arriveEarly : Float -> Movement -> Movement
* leaveSmoothly : Float -> Movement -> Movement
* arriveSmoothly : Float -> Movement -> Movement
* withWobble : Float -> Movement -> Movement

## Resting at a state

* type alias Oscillator = Oscillator
* wave : Float -> Float -> Oscillator
* wrap : Float -> Float -> Oscillator
* zigzag : Float -> Float -> Oscillator
* interpolate : (Float -> Float) -> Oscillator
* loop : Duration -> Oscillator -> Movement
* once : Duration -> Oscillator -> Movement
* repeat : Int -> Duration -> Oscillator -> Movement
* shift : Float -> Oscillator -> Oscillator

## Sprites

* step : Timeline state -> (state -> Frames sprite) -> sprite
* type alias Frames item = Frames item
* frame : sprite -> Frames sprite
* hold : Int -> sprite -> Frames sprite
* walk : sprite -> List (Frames sprite) -> Frames sprite
* framesWith : { transition : Frames item , resting : Resting item } -> Frames item
* type alias Resting item = Resting item
* type FramesPerSecond
* fps : Float -> FramesPerSecond
* cycle : FramesPerSecond -> List (Frames sprite) -> Resting sprite    
* cycleN : Int -> FramesPerSecond -> List (Frames sprite) -> Resting sprite

# Animator.Inline

## Inline Styles

opacity : Timeline state -> (state -> Movement) -> Attribute msg
backgroundColor : Timeline state -> (state -> Color) -> Attribute msg
textColor : Timeline state -> (state -> Color) -> Attribute msg
borderColor : Timeline state -> (state -> Color) -> Attribute msg

## Transformations

xy : Timeline state -> ( state -> { x : Movement , y : Movement } ) -> Attribute msg
rotate : Timeline state -> (state -> Movement) -> Attribute msg
scale : Timeline state -> (state -> Movement) -> Attribute msg
transform : { scale : Float , rotate : Float , position : { x : Float , y : Float } } -> Attribute msg

## Custom

style : Timeline state -> String -> (Float -> String) -> (state -> Movement) -> Attribute msg
linear : Timeline state -> String -> (Float -> String) -> (state -> Movement) -> Attribute msg
color : Timeline state -> String -> (state -> Color) -> Attribute msg    
