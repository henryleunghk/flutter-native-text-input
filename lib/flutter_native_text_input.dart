import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

enum ReturnKeyType {
  defaultAction,
  go,
  google,
  join,
  next,
  route,
  search,
  send,
  yahoo,
  done,
  emergencyCall,
  continueAction,
}

enum TextContentType {
  name,
  namePrefix,
  givenName,
  middleName,
  familyName,
  nameSuffix,
  nickname,
  jobTitle,
  organizationName,
  location,
  fullStreetAddress,
  streetAddressLine1,
  streetAddressLine2,
  addressCity,
  addressState,
  addressCityAndState,
  sublocality,
  countryName,
  postalCode,
  telephoneNumber,
  emailAddress,
  url,
  creditCardNumber,
  username,
  password,
  newPassword, // iOS12+
  oneTimeCode // iOS12+
}

enum KeyboardType {
  /// Default type for the current input method.
  defaultType,

  /// Displays a keyboard which can enter ASCII characters
  asciiCapable,

  /// Numbers and assorted punctuation.
  numbersAndPunctuation,

  /// A type optimized for URL entry (shows . / .com prominently).
  url,

  /// A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN
  numberPad,

  /// A phone pad (1-9, *, 0, #, with letters under the numbers).
  phonePad,

  /// A type optimized for entering a person's name or phone number.
  namePhonePad,

  /// A type optimized for multiple email address entry (shows space @ . prominently).
  emailAddress,

  /// A number pad with a decimal point. iOS 4.1+.
  decimalPad,

  /// A type optimized for twitter text entry (easy access to @ #).
  twitter,

  /// A default keyboard type with URL-oriented addition (shows space . prominently).
  webSearch,

  // A number pad (0-9) that will always be ASCII digits. Falls back to KeyboardType.numberPad below iOS 10.
  asciiCapableNumberPad
}

class NativeTextInput extends StatefulWidget {
  static const viewType = 'flutter_native_text_input';

  const NativeTextInput({
    Key? key,
    this.controller,
    this.decoration,
    this.focusNode,
    this.iosOptions,
    this.keyboardType = KeyboardType.defaultType,
    this.maxLines = 1,
    this.minHeightPadding = 18,
    this.minLines = 1,
    this.placeholder,
    this.placeholderColor,
    this.returnKeyType = ReturnKeyType.done,
    this.style,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textContentType,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
  }) : super(key: key);

  /// Controlling the text being edited
  /// (https://api.flutter.dev/flutter/material/TextField/controller.html)
  ///
  /// Default: null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Controls the BoxDecoration of the box behind the text input
  /// (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/decoration.html)
  ///
  /// Default: null
  final BoxDecoration? decoration;

  /// Defines the keyboard focus for this widget
  /// (https://api.flutter.dev/flutter/material/TextField/focusNode.html)
  ///
  /// Default: null
  final FocusNode? focusNode;

  /// iOS only options (cursorColor, keyboardAppearance)
  ///
  /// Default: null
  final IosOptions? iosOptions;

  /// Type of keyboard to display for a given text-based view
  /// (https://developer.apple.com/documentation/uikit/uikeyboardtype)
  ///
  /// Default: KeyboardType.defaultType
  final KeyboardType keyboardType;

  /// Extra vertical spacing added in addition to line height for iOS UITextView to fit well in single line mode
  /// Note: Text content height would be used instead if it is greater than this value
  ///
  /// Default: 18.0
  final double minHeightPadding;

  /// The maximum number of lines to show at one time, wrapping if necessary
  /// (https://api.flutter.dev/flutter/material/TextField/maxLines.html)
  ///
  /// Default: 1
  final int maxLines;

  /// Minimum number of lines of text input widget
  ///
  /// Default: 1
  final int minLines;

  /// Placeholder text when text entry is empty
  /// (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/placeholder.html)
  ///
  /// Default: null
  final String? placeholder;

  /// The text color to use for the placeholder text
  ///
  /// Default: null
  final Color? placeholderColor;

  /// Constants that specify the text string that displays in the Return key of a keyboard
  /// (https://developer.apple.com/documentation/uikit/uireturnkeytype)
  ///
  /// Default: ReturnKeyType.defaultAction
  final ReturnKeyType returnKeyType;

  /// The style to use for the text being edited [Only `fontSize`, `fontWeight`, `color` are supported]
  /// (https://api.flutter.dev/flutter/material/TextField/style.html)
  ///
  /// Default: null
  final TextStyle? style;

  /// How the text should be aligned horizontally
  /// (https://api.flutter.dev/flutter/material/TextField/textAlign.html)
  ///
  /// Default: TextAlign.start
  final TextAlign textAlign;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard
  /// (https://api.flutter.dev/flutter/material/TextField/textCapitalization.html)
  ///
  /// Default: TextCapitalization.none
  final TextCapitalization textCapitalization;

  /// To identify the semantic meaning expected for a text-entry area
  /// (https://developer.apple.com/documentation/uikit/uitextcontenttype)
  ///
  /// Default: null
  final TextContentType? textContentType;

  /// Called when the user initiates a change to text entry
  /// (https://api.flutter.dev/flutter/material/TextField/onChanged.html)
  ///
  /// Default: null
  final ValueChanged<String>? onChanged;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  /// (https://api.flutter.dev/flutter/material/TextField/onEditingComplete.html)
  ///
  /// Default: null
  final VoidCallback? onEditingComplete;

  /// Called when the user indicates that they are done editing the text in the field
  /// (https://api.flutter.dev/flutter/material/TextField/onSubmitted.html)
  ///
  /// Default: null
  final ValueChanged<String?>? onSubmitted;

  /// Called when the user taps the field.
  ///
  /// Not implemented yet on Android.
  ///
  /// Default: null
  final VoidCallback? onTap;

  @override
  State<StatefulWidget> createState() => _NativeTextInputState();
}

class IosOptions {
  /// Whether autocorrect is enabled.
  ///
  /// Default: null
  final bool? autocorrect;

  /// The color of the cursor
  /// (https://api.flutter.dev/flutter/material/TextField/cursorColor.html)
  ///
  /// Default: null
  final Color? cursorColor;

  /// The appearance of the keyboard
  /// (https://api.flutter.dev/flutter/material/TextField/keyboardAppearance.html)
  ///
  /// Default: null
  final Brightness? keyboardAppearance;

  /// The style to use for the placeholder text. [Only `fontSize`, `fontWeight` are supported]
  /// (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/placeholderStyle.html)
  ///
  /// Default: null
  final TextStyle? placeholderStyle;

  IosOptions({
    this.autocorrect,
    this.cursorColor,
    this.keyboardAppearance,
    this.placeholderStyle,
  });
}

class _NativeTextInputState extends State<NativeTextInput> {
  final Completer<MethodChannel> _channel = Completer();

  TextEditingController? _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? (_controller ??= TextEditingController());

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get _isMultiline => widget.maxLines == 0 || widget.maxLines > 1;
  double _lineHeight = 22.0;
  double _contentHeight = 22.0;

  @override
  void initState() {
    super.initState();

    _effectiveFocusNode.addListener(_focusNodeListener);
    widget.controller?.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_focusNodeListener);
    widget.controller?.removeListener(_controllerListener);

    _controller?.dispose();
    _focusNode?.dispose();

    super.dispose();
  }

  Future<void> _focusNodeListener() async {
    final MethodChannel channel = await _channel.future;
    if (mounted) {
      channel.invokeMethod(_effectiveFocusNode.hasFocus ? "focus" : "unfocus");
    }
  }

  Future<void> _controllerListener() async {
    final MethodChannel channel = await _channel.future;
    channel.invokeMethod(
      "setText",
      {"text": widget.controller?.text ?? ''},
    );
    channel.invokeMethod("getContentHeight").then((value) {
      if (value != null && value != _contentHeight) {
        setState(() {
          _contentHeight = value;
        });
      }
    });
  }

  Widget _platformView(BoxConstraints layout) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: NativeTextInput.viewType,
          surfaceFactory: (context, controller) => AndroidViewSurface(
            controller: controller as AndroidViewController,
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          ),
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: NativeTextInput.viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: _buildCreationParams(layout),
              creationParamsCodec: const StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener((_) {
                params.onPlatformViewCreated(_);
                _createMethodChannel(_);
              })
              ..create();
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: NativeTextInput.viewType,
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: _buildCreationParams(layout),
          onPlatformViewCreated: _createMethodChannel,
        );
      default:
        return CupertinoTextField(
          controller: widget.controller,
          cursorColor: widget.iosOptions?.cursorColor,
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: Colors.transparent),
          ),
          focusNode: widget.focusNode,
          keyboardAppearance: widget.iosOptions?.keyboardAppearance,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          placeholder: widget.placeholder,
          placeholderStyle: TextStyle(color: widget.placeholderColor),
          textAlign: widget.textAlign,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: _minHeight,
        maxHeight: _maxHeight > _minHeight ? _maxHeight : _minHeight,
      ),
      child: LayoutBuilder(
        builder: (context, layout) => Container(
          decoration: widget.decoration,
          child: _platformView(layout),
        ),
      ),
    );
  }

  void _createMethodChannel(int nativeViewId) {
    MethodChannel channel =
        MethodChannel("flutter_native_text_input$nativeViewId")
          ..setMethodCallHandler(_onMethodCall);
    channel.invokeMethod("getLineHeight").then((value) {
      if (value != null) {
        setState(() {
          _lineHeight = value;
        });
      }
    });
    channel.invokeMethod("getContentHeight").then((value) {
      if (value != null) {
        setState(() {
          _contentHeight = value;
        });
      }
    });
    _channel.complete(channel);
  }

  Map<String, dynamic> _buildCreationParams(BoxConstraints constraints) {
    Map<String, dynamic> params = {
      "maxLines": widget.maxLines,
      "minHeightPadding": widget.minHeightPadding,
      "minLines": widget.minLines,
      "placeholder": widget.placeholder ?? "",
      "returnKeyType": widget.returnKeyType.toString(),
      "text": _effectiveController.text,
      "textAlign": widget.textAlign.toString(),
      "textCapitalization": widget.textCapitalization.toString(),
      "textContentType": widget.textContentType?.toString(),
      "keyboardAppearance": widget.iosOptions?.keyboardAppearance.toString(),
      "keyboardType": widget.keyboardType.toString(),
      "width": constraints.maxWidth,
    };

    if (widget.style != null && widget.style?.fontSize != null) {
      params = {
        ...params,
        "fontSize": widget.style?.fontSize,
      };
    }

    if (widget.style != null && widget.style?.fontWeight != null) {
      params = {
        ...params,
        "fontWeight": widget.style?.fontWeight.toString(),
      };
    }

    if (widget.style != null && widget.style?.fontFamily != null) {
      params = {
        ...params,
        "fontFamily": widget.style?.fontFamily.toString(),
      };
    }

    if (widget.style != null && widget.style?.color != null) {
      params = {
        ...params,
        "fontColor": {
          "red": widget.style?.color?.red,
          "green": widget.style?.color?.green,
          "blue": widget.style?.color?.blue,
          "alpha": widget.style?.color?.alpha,
        }
      };
    }

    if (widget.iosOptions?.placeholderStyle != null &&
        widget.iosOptions?.placeholderStyle?.fontSize != null) {
      params = {
        ...params,
        "placeholderFontSize": widget.iosOptions?.placeholderStyle?.fontSize,
      };
    }

    if (widget.iosOptions?.placeholderStyle != null &&
        widget.iosOptions?.placeholderStyle?.fontWeight != null) {
      params = {
        ...params,
        "placeholderFontWeight":
            widget.iosOptions?.placeholderStyle?.fontWeight.toString(),
      };
    }

    if (widget.iosOptions?.placeholderStyle != null &&
        widget.iosOptions?.placeholderStyle?.fontFamily != null) {
      params = {
        ...params,
        "placeholderFontFamily":
        widget.iosOptions?.placeholderStyle?.fontFamily.toString(),
      };
    }

    if (widget.placeholderColor != null) {
      params = {
        ...params,
        "placeholderFontColor": {
          "red": widget.placeholderColor?.red,
          "green": widget.placeholderColor?.green,
          "blue": widget.placeholderColor?.blue,
          "alpha": widget.placeholderColor?.alpha,
        },
      };
    }

    if (widget.iosOptions?.cursorColor != null) {
      params = {
        ...params,
        "cursorColor": {
          "red": widget.iosOptions!.cursorColor?.red,
          "green": widget.iosOptions!.cursorColor?.green,
          "blue": widget.iosOptions!.cursorColor?.blue,
          "alpha": widget.iosOptions!.cursorColor?.alpha,
        },
      };
    }

    if (widget.iosOptions?.autocorrect != null) {
      params = {
        ...params,
        "autocorrect": widget.iosOptions!.autocorrect,
      };
    }

    if (widget.onTap != null) {
      params = {
        ...params,
        "onTap": true,
      };
    }

    return params;
  }

  Future<bool?> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "inputValueChanged":
        final String? text = call.arguments["text"];
        final int? lineIndex = call.arguments["currentLine"];
        _inputValueChanged(text, lineIndex);
        return null;

      case "inputStarted":
        _inputStarted();
        return null;

      case "inputFinished":
        final String? text = call.arguments["text"];
        _inputFinished(text);
        return null;

      case "singleTapRecognized":
        _singleTapRecognized();
    }

    throw MissingPluginException(
        "NativeTextInput._onMethodCall: No handler for ${call.method}");
  }

  double get _minHeight =>
      (widget.minLines * _lineHeight) + widget.minHeightPadding;

  double get _maxHeight {
    if (!_isMultiline) return _minHeight;
    if (_contentHeight > _minHeight && widget.maxLines > 0) {
      double maxLineHeight = widget.maxLines * _lineHeight;
      if (defaultTargetPlatform == TargetPlatform.android) {
        maxLineHeight += widget.minHeightPadding;
      }
      return _contentHeight > maxLineHeight ? maxLineHeight : _contentHeight;
    }
    if (_contentHeight > _minHeight) return _contentHeight;
    return _minHeight;
  }

  // input control methods
  void _inputStarted() {
    _scrollIntoView();
    if (!_effectiveFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_effectiveFocusNode);
    }
  }

  void _inputFinished(String? text) async {
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete!();
    } else {
      final channel = await _channel.future;
      channel.invokeMethod("unfocus");
      if (_effectiveFocusNode.hasFocus) FocusScope.of(context).unfocus();
    }
    if (widget.onSubmitted != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      widget.onSubmitted!(text);
    }
  }

  void _inputValueChanged(String? text, int? lineIndex) async {
    if (text != null) {
      _effectiveController.text = text;
      if (widget.onChanged != null) widget.onChanged!(text);

      final channel = await _channel.future;
      final value = await channel.invokeMethod("getContentHeight");
      if (mounted && value != null && value != _contentHeight) {
        _contentHeight = value;
        setState(() {});
      }
    }
  }

  void _singleTapRecognized() => widget.onTap?.call();

  static const Duration _caretAnimationDuration = Duration(milliseconds: 100);
  static const Curve _caretAnimationCurve = Curves.fastOutSlowIn;

  void _scrollIntoView() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.findRenderObject()!.showOnScreen(
            duration: _caretAnimationDuration,
            curve: _caretAnimationCurve,
          );
    });
  }
}
