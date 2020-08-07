# Native Text Input for Flutter

A text input widget built with the use of `UITextView` for supporting native text view features. This package supports iOS only for now.

## Why using this?

**Autocorrect tooltips don't appear on iOS**
(https://github.com/flutter/flutter/issues/12920)

Many iOS users have established a habit for using convenience features of native `UITextView`. No doubt that Flutter provides a lot of useful widgets. However, most Flutter developers should notice that `TextField` or `CupertinoTextField` provided by Flutter are not using native UI components and hence text input experience becomes different.

Regarding this, this package aims to simply provide the interface to other developers to use native `UITextView` directly in your Flutter app.

![](demo/flutter-textfield.gif)
![](demo/native-textview.gif)

The above is just showing one of missing features comparing Flutter `TextField` from native `UITextView`, there are some others your app users may find text inputs in your Flutter apps are different from others apps. Those features would be important if you are developing apps which involve composing a text message, messaging app for example.

Hope you find it useful! Enjoy coding 🎉🎉🎉

## License

This project is licenced under the [MIT License](http://opensource.org/licenses/mit-license.html).
