# Native Text Input for Flutter

A text input widget built using the native `UITextView` on iOS (this package only supports iOS for now).

## Installation

Follow the instructions from https://pub.dev/packages/flutter_native_text_input/install

## Why you should use this

Many iOS users are used to the subtle features provided by the native `UITextView` throughout iOS. Even though Flutter provides a lot of useful widgets, many Flutter developers will notice that `TextField` or `CupertinoTextField` provided by Flutter are [not on par with their native counterpart][1].

![](demo/flutter-textfield.gif)
![](demo/native-textview.gif)

The above shows just one of the missing text editing features in Flutter's `TextField`, when comparing to the native `UITextView`. Features like these are especially important if you're building an app that involves a lot of text composition (messaging, editing document, and so on).

To address this, this package simply wraps the native `UITextView` as a Flutter widget.

Hope you find it useful and happy coding! 🎉🎉🎉

## Plugin API

| Name            | Type          | Description                    | Default                  |
|:----------------|:--------------|:-------------------------------|:-------------------------|
| `controller`      | TextEditingController  | Controlling the text being edited (https://api.flutter.dev/flutter/material/TextField/controller.html) | null |
| `style`           | TextStyle              | The style to use for the text being edited [Only `fontSize`, `fontWeight`, `color` are supported] (https://api.flutter.dev/flutter/painting/TextStyle-class.html) | null |
| `placeholderStyle` | TextStyle             | The style to use for the placeholder text. [Only `fontSize`, `fontWeight`, `color` are supported] (https://api.flutter.dev/flutter/painting/TextStyle-class.html) | null |
| `placeholder`     | String                 | Placeholder text when text entry is empty (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/placeholder.html) | null |
| `textContentType` | TextContentType        | To identify the semantic meaning expected for a text-entry area (https://developer.apple.com/documentation/uikit/uitextcontenttype) | null |
| `keyboardAppearance` | Brightness          | The appearance of the keyboard (https://api.flutter.dev/flutter/material/TextField/keyboardAppearance.html) | null |
| `keyboardType`    | KeyboardType           | Type of keyboard to display for a given text-based view (https://developer.apple.com/documentation/uikit/uikeyboardtype) | KeyboardType.defaultType |
| `onChanged`       | ValueChanged\<String>  | Called when the user initiates a change to text entry (https://api.flutter.dev/flutter/material/TextField/onChanged.html) | null |
| `onSubmitted`     | ValueChanged\<String>  | Called when the user indicates that they are done editing the text in the field (https://api.flutter.dev/flutter/material/TextField/onSubmitted.html) | null |
| `focusNode`       | FocusNode              | Defines the keyboard focus for this widget (https://api.flutter.dev/flutter/material/TextField/focusNode.html) | null |
| `textAlign`       | TextAlign              | How the text should be aligned horizontally (https://api.flutter.dev/flutter/material/TextField/textAlign.html) | TextAlign.start |
| `minLines`        | int                    | Minimum number of lines of text input widget | 1 |
| `maxLines`        | int                    | Maximum number of lines of text input body, 0 for no limit | 1 |

## More examples

You may find more usage examples [here][2].

![](demo/more-examples.gif)

## Contributing

### Found a bug?
Please do not hestitate to report that. This cuuld help improve this package.

### Feature request?
Please feel free to create an issue.

### Pull request?
Contributors are welcome. Just create a PR and it would be reviewed and merged ASAP.

If you enjoy using this package or it helps you or your team, you could also buy me a cup of coffee to show support :)

https://PayPal.Me/hkhenryleung

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/mit-license.html).

[1]: https://github.com/flutter/flutter/issues/12920
[2]: https://github.com/henryleunghk/flutter-native-text-input/blob/master/example/lib/more_use_case_listing_page.dart
