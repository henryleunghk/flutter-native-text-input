import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  const NativeTextInput({
    Key? key,
    this.controller,
    this.cursorColor,
    this.decoration,
    this.focusNode,
    this.keyboardAppearance,
    this.keyboardType = KeyboardType.defaultType,
    this.maxLines = 1,
    this.minLines = 1,
    this.placeholder,
    this.placeholderStyle,
    this.returnKeyType = ReturnKeyType.defaultAction,
    this.style,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textContentType,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final Color? cursorColor;

  final BoxDecoration? decoration;

  final FocusNode? focusNode;

  final Brightness? keyboardAppearance;

  final KeyboardType keyboardType;

  final int maxLines;

  final int minLines;

  final ReturnKeyType returnKeyType;

  final String? placeholder;

  final TextStyle? placeholderStyle;

  final TextStyle? style;

  final TextAlign textAlign;

  final TextCapitalization textCapitalization;

  final TextContentType? textContentType;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String?>? onSubmitted;

  @override
  State<StatefulWidget> createState() => _NativeTextInputState();
}

class _NativeTextInputState extends State<NativeTextInput> {
  late MethodChannel _channel;

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

    _effectiveFocusNode.addListener(() {
      if (_effectiveFocusNode.hasFocus) {
        _channel.invokeMethod("focus");
      } else {
        _channel.invokeMethod("unfocus");
      }
    });

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        _channel
            .invokeMethod("setText", {"text": widget.controller?.text ?? ''});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: _minHeight,
        maxHeight: _maxHeight,
      ),
      child: LayoutBuilder(
        builder: (context, layout) => Container(
          decoration: widget.decoration,
          child: UiKitView(
            viewType: "flutter_native_text_input",
            creationParamsCodec: const StandardMessageCodec(),
            creationParams: _buildCreationParams(layout),
            onPlatformViewCreated: _createMethodChannel,
          ),
        ),
      ),
    );
  }

  void _createMethodChannel(int nativeViewId) {
    _channel = MethodChannel("flutter_native_text_input$nativeViewId")
      ..setMethodCallHandler(_onMethodCall);
    _channel.invokeMethod("getLineHeight").then((value) {
      if (value != null) {
        _lineHeight = value;
        setState(() {});
      }
    });
    _channel.invokeMethod("getContentHeight").then((value) {
      if (value != null) {
        _contentHeight = value;
        setState(() {});
      }
    });
  }

  Map<String, dynamic> _buildCreationParams(BoxConstraints constraints) {
    Map<String, dynamic> params = {
      "maxLines": widget.maxLines,
      "placeholder": widget.placeholder ?? "",
      "returnKeyType": widget.returnKeyType.toString(),
      "text": _effectiveController.text,
      "textAlign": widget.textAlign.toString(),
      "textCapitalization": widget.textCapitalization.toString(),
      "textContentType": widget.textContentType?.toString(),
      "keyboardAppearance": widget.keyboardAppearance.toString(),
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

    if (widget.placeholderStyle != null &&
        widget.placeholderStyle?.fontSize != null) {
      params = {
        ...params,
        "placeholderFontSize": widget.placeholderStyle?.fontSize,
      };
    }

    if (widget.placeholderStyle != null &&
        widget.placeholderStyle?.fontWeight != null) {
      params = {
        ...params,
        "placeholderFontWeight": widget.placeholderStyle?.fontWeight.toString(),
      };
    }

    if (widget.placeholderStyle != null &&
        widget.placeholderStyle?.color != null) {
      params = {
        ...params,
        "placeholderFontColor": {
          "red": widget.placeholderStyle?.color?.red,
          "green": widget.placeholderStyle?.color?.green,
          "blue": widget.placeholderStyle?.color?.blue,
          "alpha": widget.placeholderStyle?.color?.alpha,
        },
      };
    }

    if (widget.cursorColor != null) {
      params = {
        ...params,
        "cursorColor": {
          "red": widget.cursorColor?.red,
          "green": widget.cursorColor?.green,
          "blue": widget.cursorColor?.blue,
          "alpha": widget.cursorColor?.alpha,
        },
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
    }

    throw MissingPluginException(
        "NativeTextInput._onMethodCall: No handler for ${call.method}");
  }

  double get _minHeight => (widget.minLines * _lineHeight) + 18;

  double get _maxHeight {
    if (!_isMultiline) return _minHeight;
    if (_contentHeight > _minHeight && widget.maxLines > 0) {
      double maxLineHeight = widget.maxLines * _lineHeight + 14;
      return _contentHeight > maxLineHeight ? maxLineHeight : _contentHeight;
    }
    if (_contentHeight > _minHeight) return _contentHeight;
    return _minHeight;
  }

  // input control methods
  void _inputStarted() {
    _scrollIntoView();
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      FocusScope.of(context).requestFocus(_effectiveFocusNode);
    });
  }

  void _inputFinished(String? text) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(text);
    }
  }

  void _inputValueChanged(String? text, int? lineIndex) {
    if (text != null) {
      _effectiveController.text = text;
      if (widget.onChanged != null) widget.onChanged!(text);

      _channel.invokeMethod("getContentHeight").then((value) {
        if (value != null && value != _contentHeight) {
          _contentHeight = value;
          setState(() {});
        }
      });
    }
  }

  static const Duration _caretAnimationDuration = Duration(milliseconds: 100);
  static const Curve _caretAnimationCurve = Curves.fastOutSlowIn;

  void _scrollIntoView() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      context.findRenderObject()!.showOnScreen(
            duration: _caretAnimationDuration,
            curve: _caretAnimationCurve,
          );
    });
  }
}
