
Notes for Matthew

* I wonder if Animator.watching and Animator.watchingWith should rather go into Animator.Inline, the same as Animator.Css.watching
* If not, add a note to Animator.watching
* Maybe a "lazy" animator with (\_ -> False)


==== Stuff used

## Timeline

* Animator.Timeline                                 -- in the model
* Animator.Timeline.init : state -> Timeline state  -- in the init

### Animator/Watching

* used in the `update` and `subscriptions`)
* is possible to add any number of timelines to an animator

* type alias Animator model = Animator model
* Animator.watching     : (model -> Timeline state) -> (Timeline state -> model -> model) -> Animator model -> Animator model -- Could this be Animator.Inline.watching?
* Animator.Css.watching : (model -> Timeline state) -> (Timeline state -> model -> model) -> Animator model -> Animator model
* Animator.watchingWith  -- Could this be Animator.Inline.watchingWith?
* Animator.animator

## Updated

Boilerplate

* Animator.update

Not boilerplate

* Animator.go
* Animator.seconds
* Animator.current

## Subscription

* Animator.toSubscription

## Inline

* Animator.Inline.rotate
* Animator.Inline.style
* Animator.at

## Css

* Animator.Css.div
* Animator.Css.transform
* Animator.Css.rotateTo
* Animator.Css.height
* Animator.at


List of transformable properties (matrix, perspective, rotate, scale, skew, translate)
such as in "transform
https://developer.mozilla.org/en-US/docs/Web/CSS/transform-function

Non animatable CSS properties
https://greensock.com/forums/topic/13545-non-animatable-css-properties/

Additive animations
https://greensock.com/forums/topic/12573-additive-animation/

FLIP
https://aerotwist.com/blog/flip-your-animations/

List of transitionable (animatable) properties
such as in: "transition: all 0.3s"
https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_animated_properties

Animation in JS:
https://medium.com/allenhwkim/animate-with-javascript-eef772f1f3f3
https://javascript.info/js-animation#structured-animation

Intro to elm-animator
https://korban.net/posts/elm/2020-04-07-using-elm-animator-with-elm-ui/

About speed and good animations
https://uxdesign.cc/the-ultimate-guide-to-proper-use-of-animation-in-ux-10bd98614fa9

Myth Busting: CSS Animations vs. JavaScript
https://css-tricks.com/myth-busting-css-animations-vs-javascript/

Making CSS Animations Feel More Natural
https://css-tricks.com/making-css-animations-feel-natural/

Tips for Writing Animation Code Efficiently
by Zach Saucier
A lot about GSAP
Good for examples
https://css-tricks.com/tips-for-writing-animation-code-efficiently/

Writing Animations That Bring Your Site to Life
"Avoid animating CSS properties other than transform and opacity.", tutorial in Vue
https://css-tricks.com/writing-animations-that-bring-your-site-to-life/


The Importance of Context-Shifting in UX Patterns
https://css-tricks.com/the-importance-of-context-shifting-in-ux-patterns/

Animation in the web is a bit the new Jquery
