# FB25460015: `UIButton` and SwiftUI `Menu` report a non-finite `accessibilityActivationPoint`

## Summary

`UIButton` returns a non-finite `accessibilityActivationPoint` when it has no subviews, or when all of its subviews have a zero-size frame. The value is `(inf, inf)`, the center of `CGRect.null`, which is not a location on the screen. The button's `accessibilityFrame` is valid.

Every SwiftUI `Menu` reports the same `(inf, inf)`. Each `Menu` is drawn by a `UIButton` subclass that has no subviews.

VoiceOver still opens the menu on a double-tap (verified on iOS 26.2.1). Clients that read `accessibilityActivationPoint` directly, such as UI automation and accessibility auditing tools, get a value that they can't hit-test, tap or encode as JSON.

## Steps to reproduce

1. On a device, turn on VoiceOver. On a simulator, open Accessibility Inspector.
2. Run the `ActivationPointRepro` scheme.
3. A quarter of a second after launch, the app prints the `accessibilityActivationPoint` and `accessibilityFrame` of each accessibility element. It finds the elements with public API only.

The app shows three controls: a SwiftUI `Menu`, a `UIButton(type: .system)` with a title, and the same button without a title.

## Expected

Each element returns the documented default, the midpoint of its `accessibilityFrame`, as `UIView` and `UIControl` do.

## Actual

iPhone 15 Pro, iOS 26.2.1:

```
"SwiftUI Menu" activationPoint=(inf, inf) accessibilityFrame=(145.66666666666666, 363.3333333333333, 101.66666666666666, 22.333333333333314)
"UIKit Button With Title" activationPoint=(196.66666666666663, 427.66666666666663) accessibilityFrame=(76.66666666666666, 405.66666666666663, 239.99999999999997, 44.0)
"UIKit Button Without Title" activationPoint=(inf, inf) accessibilityFrame=(76.66666666666666, 469.66666666666663, 239.99999999999997, 44.0)
```

## Reproduced on

| Environment | Result |
| --- | --- |
| iPhone 15 Pro, iOS 26.2.1 | Reproduces |
| Simulator, iOS 26.5 | Reproduces |
| Simulator, iOS 27.1 | Reproduces |

Built with Xcode 27.1.
