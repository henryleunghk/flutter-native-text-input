import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
    this.decoration,
    this.style,
    this.placeholderStyle,
    this.placeholder,
    this.textContentType,
    this.keyboardAppearance,
    this.keyboardType = KeyboardType.defaultType,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.minLines = 1,
    this.maxLines = 1,
  }) : super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final BoxDecoration? decoration;

  final TextStyle? style;

  final TextStyle? placeholderStyle;

  /// A lighter colored placeholder hint that appears on the first line of the
  /// text field when the text entry is empty.
  ///
  /// Defaults to having no placeholder text.
  ///
  /// The text style of the placeholder text matches that of the text field's
  /// main text entry except a lighter font weight and a grey font color.
  final String? placeholder;

  final TextContentType? textContentType;

  final Brightness? keyboardAppearance;

  final KeyboardType keyboardType;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String?>? onSubmitted;

  final FocusNode? focusNode;

  final TextAlign textAlign;

  final int maxLines;

  final int minLines;

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
  int? _currentLineIndex = 1;
  double _lineHeight = 22.0;

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
        minHeight: _minHeight(),
        maxHeight: _maxHeight(),
      ),
      child: Container(
        decoration: widget.decoration,
        child: UiKitView(
          viewType: "flutter_native_text_input",
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: _buildCreationParams(),
          onPlatformViewCreated: _createMethodChannel,
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
  }

  Map<String, dynamic> _buildCreationParams() {
    Map<String, dynamic> params = {
      "text": _effectiveController.text,
      "placeholder": widget.placeholder ?? "",
      "textContentType": widget.textContentType?.toString(),
      "keyboardAppearance": widget.keyboardAppearance.toString(),
      "keyboardType": widget.keyboardType.toString(),
      "textAlign": widget.textAlign.toString(),
      "maxLines": widget.maxLines,
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

  double _minHeight() {
    double height = widget.minLines * _lineHeight + 16;
    return height > 36 ? height : 36;
  }

  double _maxHeight() {
    return _isMultiline
        ? (_lineHeight * _currentLineIndex! > _minHeight()
            ? _lineHeight * _currentLineIndex!
            : _minHeight())
        : _minHeight();
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
      if (_isMultiline &&
          _currentLineIndex != lineIndex &&
          lineIndex! <= widget.maxLines) {
        setState(() {
          _currentLineIndex = lineIndex;
        });
      } else {
        _currentLineIndex = 0;
      }

      if (widget.onChanged != null) widget.onChanged!(text);
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
