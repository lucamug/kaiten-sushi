In this tutorial we will analyze several techniques to implement a simple animation of a sushi plate moving on a conveyor.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/tmwp4cpthioe7iyj3k64.gif)

We will start from CSS, go through Javascript and arrive at Elm.

Part I (this one)

1. CSS Transition
2. CSS Animation
3. Vanilla Javascript Animation
4. Vanilla Elm Animation
5. elm-animator Inline Animation

Part II (under development)

6. elm-animator Inline Animation II
7. elm-animator Hybrid Animation
8. elm-playground SVG Animation
9. elm-playground-3d SVG Animation
10. Elm WebGL Animation














# Why Elm?

There are several reasons that make Elm an interesting selection, specifically to animation:

* There are few libraries available with interesting concepts. We will look at [elm-animator](https://package.elm-lang.org/packages/mdgriffith/elm-animator/latest/), [elm-playground](https://package.elm-lang.org/packages/evancz/elm-playground/latest/) and [WebGL for Elm](https://package.elm-lang.org/packages/elm-explorations/webgl/latest/) in this tutorial.
* The Virtual DOM optimization that Elm makes, thanks to the fact that it is a pure language, make Elm [one of the fastest framework out there](https://rawgit.com/krausest/js-framework-benchmark/master/webdriver-ts-results/table.html).
* The embedded Elm Debugger, (a.k.a Time Travelling Debugger),  makes it easy to play the animation back and forward. Very useful for debugging and fine-tuning complex animations.

From a broader point of view, the appeal of Elm is that it is a __pure functional language with a productive compiler__.

__We don't get runtime errors__ and functions are easy to read because they don't depend on any state but just on their declared inputs.

There are also advantages related to user experience, such as the finer grained dead code elimination that means [small assets and shorter loading time](https://elm-lang.org/news/small-assets-without-the-headache).

As Evan Czaplicki - the author of Elm - [puts it](https://guide.elm-lang.org/interop/limits.html): "*One of the best things about Elm is that there are entire categories of problems you just do not have to worry about. There are no surprise exceptions to catch, and functions cannot mutate data in surprising ways*."

These are couple of talks that, even if not not related directly to Elm, describe well this concept: [*Functional architecture - The pits of success*](https://www.youtube.com/watch?v=US8QG9I1XW0) by Mark Seemann and [*Refactoring to Immutability*](https://www.youtube.com/watch?v=APUCMSPiNh4) by Kevlin Henney, that contain several nice quotes such as "*OOP makes code understandable by encapsulating moving parts. FP makes code understandable by minimizing moving parts*".

Ok, back to animations...







# 1. CSS Transition

Probably the simplest animation that we can write is using [CSS transitions](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transitions/Using_CSS_transitions). CSS transitions let you move from one CSS style to another CSS style gradually. [Almost all](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_animated_properties) CSS properties can be transitioned. Some of them, like `opacity` and `transform`, perform very well, as the browser doesn't need to redraw the page (they occupy the same space in the page during the transition). The others, such as width and height, may take more resources.

CSS transitions are extremely simple, we just need to create two different styles and add `transition: 1s` into our CSS.

Clicking on the page is simply adding or removing a class:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/tx5s2ymrv8fbpt109uxa.gif)

Clicking while the animation is happening, it reverses it from whatever position is at that moment. This is not always trivial to do, as we will see later.

Pausing the animation is more complicated. It would require, for example, reading the current style using [getComputedStyle](https://developer.mozilla.org/en-US/docs/Web/API/Window/getComputedStyle) / [getPropertyValue](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration/getPropertyValue) and write them back into the element.

* [Editable Demo](https://codepen.io/lucamug/pen/JjYKBqe)
* [Demo](https://lucamug.github.io/kaiten-sushi/tutorial-01-css-transition.html)
* [Code](https://github.com/lucamug/kaiten-sushi/blob/master/docs/tutorial-01-css-transition.html)









# 2. CSS Animation

What if, instead having a transition between two states, we want to have a more complex transition across multiple states? We can add keyframes using [CSS animations](https://developer.mozilla.org/en-US/docs/Web/CSS/animation).

CSS Animations are different from CSS transitions.

* Transitions means that when a property changes it should do gradually over over a period of time
* Animations instead just run, so when the animation finish, the element go back to its original state unless we use `animation-fill-mode`

These are the keyframes that we can use to give a "cartoonish" aspect to the animation:

```css
@keyframes toTheKaiten {
    from {
        left: 600px;
        transform: scale(0)
    }

    40% {
        left: 20px;
        transform: scale(1.2, 0.8)
    }

    to {
        left: 50px;
        transform: scale(1)
    }
}

@keyframes toTheKitchen {
    from {
        left: 50px;
        transform: scale(1)
    }

    20% {
        left: 100px;
        transform: scale(0.8, 1.2)
    }

    40% {
        left: 20px;
        transform: scale(1.2, 0.8)
    }

    to {
        left: 600px;
        transform: scale(0)
    }
}
```

To control the animation we use a similar system as before, toggling a class in the DOM:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/ii23999vdhq7dpfa9r4d.gif)

To reverse an animation mid-way or to pause requires more [advanced strategy](https://css-tricks.com/controlling-css-animations-transitions-javascript/), similarly to CSS transitions.

CSS animations are usually good to create [animation that don't require much interaction](https://animista.net/play) or that are in an [infinite loop](https://projects.lukehaas.me/css-loaders/).

There is a close friend of CSS animation that is the [Web Animations API](https://css-tricks.com/css-animations-vs-web-animations-api/), but we will not cover it in this tutorial.

* [Editable Demo](https://codepen.io/lucamug/pen/bGVemOZ)
* [Demo](https://lucamug.github.io/kaiten-sushi/tutorial-02-css-animation.html)
* [Code](https://github.com/lucamug/kaiten-sushi/blob/master/docs/tutorial-02-css-animation.html)












# 3. Vanilla Javascript Animation

Let's regain some power moving to a Vanilla Javascript methodology.

So now instead of letting the browser calculate all the intermediate steps for us, we do ourselves in Javascript.

As you can see, the style in the DOM is updated at each frame, while in the two previous cases we were only changing classes:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/njggbr0c8vduica97jbv.gif)

But *with great power comes great responsibility*.

Our code is now more complicated. While certain things are easier now (e.g. pausing the animation), others are more difficult (e.g. "[easing](https://easings.net/)").

The animation would also be less smooth in most situations so, why bother? For simple animations like this one, doesn't make sense but for more complicated stuff it could be beneficial to have more control.

If you want to go down this road, using a library is probably better. There are plenty out there. In this tutorial I will examine two of them: *elm-animator* and *elm-playground*.

* [Editable Demo](https://codepen.io/lucamug/pen/PoPGpXp)
* [Demo](https://lucamug.github.io/kaiten-sushi/tutorial-03-vanilla-javascript.html)
* [Code](https://github.com/lucamug/kaiten-sushi/blob/master/docs/tutorial-03-vanilla-javascript.html)











# 4. Vanilla Elm Animation

Before moving to the elm libraries, let's refresh our knowledge of Elm rewriting the previous Vanilla Javascript example in Elm.

If you are new to Elm you can refer to a [short Elm overview](https://dev.to/lucamug/elm-beginners-tutorial-how-to-make-animated-snackbars-with-zero-css-12g1) that I wrote in my previous post or, even better, the [official documentation](https://guide.elm-lang.org/).

These two implementations are quite similar. Actually I tried to write both of them in the same order so that it is possible to compare the code side by side. I will put the comparison in a separate post.

These are the main differences:


* HTML
  * Elm: generated by the `view` function
  * Javascript: not a Javascript concern
* Subscription to `requestAnimationFrame`
  * Elm: handled by the Elm runtime using [onAnimationFrameDelta](https://package.elm-lang.org/packages/elm/browser/1.0.2/Browser-Events#onAnimationFrameDelta)
  * Javascript: handled directly with [requestAnimationFrame](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)
* Main loop
  * Elm: managed by [The Elm Architecture](https://guide.elm-lang.org/architecture/)
  * Javascript: managed directly
* DOM modifications
  * Elm: through the Virtual DOM (function `view` + `changeStyle`)
  * Javascript: directly with the [`style`](https://developer.mozilla.org/en-US/docs/Web/API/ElementCSSInlineStyle/style) property (function `changeStyle`)
* Calculation of the time passed since the previous frame (delta)
  * Elm: calculated by the Elm runtime
  * Javascript: calculated directly (function `calculateDelta`)

Now, using the Elm debugger, we can move back and forward in the animation timeline. The `Model`, among other things, store exactly the new attributes of the element that is animated: 

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/tmwp4cpthioe7iyj3k64.gif)

* [Editable Demo](https://ellie-app.com/8KVh2ZjtFTra1)  (without Elm Debugger)
* [Demo](https://lucamug.github.io/kaiten-sushi/tutorial-04-vanilla-elm.html)
* [Code](https://github.com/lucamug/kaiten-sushi/blob/master/src/Tutorial_04_VanillaElm.elm)












# 5. elm-animator Inline Animation

`elm-animator` requires some boilerplate but will handle most of the things that we were handling manually before.

## Model and Init

Before we needed to handle many things ourselves. Now is the library that will take care of most of them:

__Before__

```elm
type alias Model =
    { currentState : State
    , target : State
    , animationLength : Float
    , progress : Maybe Float
    , animationStart : State
    }

init =
    { currentState = onTheKaiten
    , animationStart = onTheKaiten
    , target = onTheKaiten
    , animationLength = 0
    , progress = Nothing
    }
```

__After__

```elm
type alias Model =
    { currentState : Animator.Timeline State }

init =
    { currentState = Animator.init onTheKaiten }
```

## Messages

elm-animator use absolute time instead of delta time:

__Before__

```elm
type Msg
    = AnimationFrame Float
    | ClickOnPage
```

__After__
```elm
type Msg
    = AnimationFrame Time.Posix
    | ClickOnPage
```

## Subscription

Subscription is also handled by the library

__Before__

```elm
subscriptions model =
    case model.progress of
        Just _ ->
            Browser.Events.onAnimationFrameDelta AnimationFrame

        Nothing ->
            Sub.none
```

__After__

```elm
subscriptions model =
    animator
        |> Animator.toSubscription AnimationFrame model
```

## Function `animationFrame`

All this part is basically gone! This is what the library is doing for us

__Before__

```elm
animationFrame model delta =
    case model.progress of
        Just progress ->
            if progress < model.animationLength then
                let
                    animationRatio =
                        Basics.min 1 (progress / model.animationLength)

                    newX =
                        model.animationStart.x
                            + (model.target.x - model.animationStart.x)
                            * animationRatio

                    newScale =
                        model.animationStart.scale
                            + (model.target.scale - model.animationStart.scale)
                            * animationRatio
                in
                { model
                    | progress = Just <| progress + delta
                    , currentState = { x = newX, scale = newScale }
                }

            else
                { model
                    | progress = Nothing
                    , currentState = model.target
                }

        Nothing ->
            model
```
__After__
```elm
animationFrame model time =
    Animator.update time animator model
```

## Function `clickOnPage`

This became simpler because the `Model` is simpler

__Before__

```elm
clickOnPage model =
    if model.target == onTheKaiten then
        { model
            | target = inTheKitchen
            , animationStart = model.currentState
            , animationLength = 1000
            , progress = Just 0
        }

    else
        { model
            | target = onTheKaiten
            , animationStart = model.currentState
            , animationLength = 1000
            , progress = Just 0
        }
```
__After__

```elm
clickOnPage model =
    if Animator.current model.currentState == onTheKaiten then
        { model
            | currentState =
                Animator.go
                    (Animator.seconds 1)
                    inTheKitchen
                    model.currentState
        }

    else
        { model
            | currentState =
                Animator.go
                    (Animator.seconds 1)
                    onTheKaiten
                    model.currentState
        }
```

## Function `changeStyle`

Here we need to handle things a bit differently

__Before__

```elm
changeStyle { scale, x } =
    [ style "transform" ("scale(" ++ String.fromFloat scale ++ ")")
    , style "left" (String.fromFloat x ++ "px")
    ]
```

__After__

```elm
changeStyle state =
    [ Animator.Inline.style
        state
        "left"
        (\float -> String.fromFloat float ++ "px")
        (\state_ ->
            if state_ == inTheKitchen then
                Animator.at inTheKitchen.x

            else
                Animator.at onTheKaiten.x
        )
    , Animator.Inline.scale
        state
        (\state_ ->
            if state_ == inTheKitchen then
                Animator.at inTheKitchen.scale

            else
                Animator.at onTheKaiten.scale
        )
    ]
```

* [Editable Demo](https://ellie-app.com/8KVjNCYQwPxa1) (without Elm Debugger)
* [Demo](https://lucamug.github.io/kaiten-sushi/tutorial-05-elm-animator-inline-1.html)
* [Code](https://github.com/lucamug/kaiten-sushi/blob/master/src/Tutorial_05_ElmAnimatorInline1.elm)

We cleaned-up a lot of code!

The model is storing some internal data needed by the library to handle the animation.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/mxmuw9hpqogq5sctdagx.gif)

We got the "easing" back by default and now we are ready to leverage the full potentiality of this library. Stay tuned for the part II of this tutorial.

Thanks to the [Elm community in Slack](https://elmlang.herokuapp.com/) for the support, specifically to [@mgriffith](https://github.com/mdgriffith) for reviewing some examples and for putting so much effort in writing `elm-animator` and to [@dmy](https://github.com/rlefevre) for fixing some bug.

Photograph: "[Inside a Conveyor Belt Sushi Shop](https://ja.wikipedia.org/wiki/%E5%9B%9E%E8%BB%A2%E5%AF%BF%E5%8F%B8#/media/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB:Tokyo-Kaiten_sushi,_Japan_(2010).jpg)" by Alberto Carrasco Casado - [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/).

