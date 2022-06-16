## 2.4.0

* support custom font families on iOS

## 2.3.0

* dispose `TextEditingController` and `FocusNode`, preventing memory leaks
* support for detecting tap gestures on iOS

## 2.2.0

* fix an iOS race condition that would cause errors when autofocusing
* implement autocorrect for iOS
* use `UITextView.attributedPlaceholder` to draw the iOS placeholder
* ensure that `BoxConstraints` are valid

## 2.1.1

* fix android text input background not transparent

## 2.1.0

* add back `placeholderStyle` in `iosOptions`

## 2.0.0

* add Android support
* wrap `cursorColor` and `keyboardAppearance` in `iosOptions`
* replace `placeholderStyle` with `placeholderColor`

## 1.3.1

* add minHeightPadding configuration

## 1.3.0

* add support of onEditingComplete

## 1.2.4

* fix focus action not working sometimes

## 1.2.3

* fix placeholder re-appeared upon widget rebuilt

## 1.2.2

* fix focusNode usage

## 1.2.1

* fix returnKeyType and onSubmitted usage

## 1.2.0

* add support of cursorColor, returnKeyType and textCapitalization

## 1.1.1

* fix maxLines usage and support dynamic content height

## 1.1.0

* support customizations

## 1.0.0

* support null-safety

## 0.1.3

* fix Chinese typing issue

## 0.1.2

* fix input height not returning default on clearing multi-line text

## 0.1.1

* update examples

## 0.1.0

* support dynamic widget height with plugin documentation added

## 0.0.2

* update usage example

## 0.0.1

* initial release with iOS support
