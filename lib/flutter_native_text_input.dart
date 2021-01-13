import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef NativeTextValueChanged = void Function(String text, int linesCount);

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

class NativeTextInputController {
  _NativeTextInputState _nativeTextInputState;

  void _addState(_NativeTextInputState nativeTextInputState) {
    this._nativeTextInputState = nativeTextInputState;
  }

  /// Determine if the CustomWidgetController is attached to an instance
  /// of the CustomWidget (this property must return true before any other
  /// functions can be used)
  bool get isAttached => _nativeTextInputState != null;

  /// Here is the method you are exposing
  void emptyText() {
    assert(isAttached,
        "NativeTextInputController must be attached to a NativeTextInputState");
    _nativeTextInputState.emptyText();
  }
}

class NativeTextInput extends StatefulWidget {
  const NativeTextInput({
    Key key,
    this.controller,
    this.nativeTextInputController,
    this.placeholder,
    this.textContentType,
    this.keyboardType = KeyboardType.defaultType,
    this.onChanged,
    this.onChangedWithLines,
    this.onSubmitted,
    this.onSubmittedWithLines,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.minLines = 1,
    this.maxLines = 1,
    this.autoHeightMaxLines = 1,
    this.autoHeightMaxHeight = 0,
  }) : super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  final NativeTextInputController nativeTextInputController;

  /// A lighter colored placeholder hint that appears on the first line of the
  /// text field when the text entry is empty.
  ///
  /// Defaults to having no placeholder text.
  ///
  /// The text style of the placeholder text matches that of the text field's
  /// main text entry except a lighter font weight and a grey font color.
  final String placeholder;

  final TextContentType textContentType;

  final KeyboardType keyboardType;

  final ValueChanged<String> onChanged;
  final NativeTextValueChanged onChangedWithLines;

  final ValueChanged<String> onSubmitted;
  final NativeTextValueChanged onSubmittedWithLines;

  final FocusNode focusNode;

  final TextAlign textAlign;

  final int maxLines;

  final int minLines;

  final int autoHeightMaxLines;
  final int autoHeightMaxHeight;

  @override
  State<StatefulWidget> createState() => _NativeTextInputState();
}

class _NativeTextInputState extends State<NativeTextInput> {
  MethodChannel _channel;

  TextEditingController _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? (_controller ??= TextEditingController());

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get _isMultiline => widget.maxLines == 0 || widget.maxLines > 1;
  int _currentLineIndex = 1;
  int _currentHeight = 1;

  @override
  void initState() {
    super.initState();

    if (_effectiveFocusNode != null) {
      _effectiveFocusNode.addListener(() {
        if (_effectiveFocusNode.hasFocus) {
          _channel.invokeMethod("focus");
        } else {
          _channel.invokeMethod("unfocus");
        }
      });
    }

    if (widget.nativeTextInputController != null) {
      widget.nativeTextInputController._addState(this);
    }

    if (widget.controller != null) {
      widget.controller.addListener(() {
        _channel
            .invokeMethod("setText", {"text": widget.controller.text ?? ""});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: _minHeight(), maxHeight: _maxHeight()),
      child: UiKitView(
          viewType: "flutter_native_text_input",
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: _buildCreationParams(),
          onPlatformViewCreated: _createMethodChannel),
    );
  }

  emptyText() {
    _channel.invokeMethod("emptyText");

    setState(() {
      _currentLineIndex = 1;
      _currentHeight = 1;
    });
  }

  void _createMethodChannel(int nativeViewId) {
    _channel = MethodChannel("flutter_native_text_input$nativeViewId")
      ..setMethodCallHandler(_onMethodCall);
  }

  Map<String, dynamic> _buildCreationParams() {
    return {
      "text": _effectiveController.text ?? "",
      "placeholder": widget.placeholder ?? "",
      "textContentType": widget.textContentType?.toString(),
      "keyboardType": widget.keyboardType?.toString(),
      "textAlign": widget.textAlign.toString(),
      "maxLines": widget.maxLines,
    };
  }

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "inputValueChanged":
        final String text = call.arguments["text"];
        final int lineIndex = call.arguments["currentLine"];
        final int height = call.arguments["height"];
        _inputValueChanged(text, lineIndex, height);
        return null;

      case "inputStarted":
        _inputStarted();
        return null;

      case "inputFinished":
        final String text = call.arguments["text"];
        _inputFinished(text);
        return null;

      case "debug_msg":
        final int numb = call.arguments["numb"];
        print("debug_msg: $numb");
        return null;
    }

    throw MissingPluginException(
        "NativeTextInput._onMethodCall: No handler for ${call.method}");
  }

  double _minHeight() {
    return widget.minLines * 22.0 > 36.0 ? widget.minLines * 22.0 : 36.0;
  }

  double _maxHeight() {
    if (_isMultiline) {
      double res = _minHeight();

      // calculate based on height
      if (widget.autoHeightMaxHeight > 0) {
        if (_currentHeight > res) {
          if (_currentHeight < widget.autoHeightMaxHeight) {
            res = _currentHeight * 1.0;
          } else {
            res = widget.autoHeightMaxHeight * 1.0;
          }
        }
        // calculate based on lines
      } else {
        if (22.0 * _currentLineIndex > res) {
          if (_currentLineIndex <= widget.autoHeightMaxLines ||
              widget.autoHeightMaxLines == 0) {
            res = 22.0 * _currentLineIndex;
          } else {
            res = 22.0 * widget.autoHeightMaxLines;
          }
        }
      }

      return res;
    }
    return 36.0;
  }

  // input control methods
  void _inputStarted() {
    _scrollIntoView();
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      FocusScope.of(context).requestFocus(_effectiveFocusNode);
    });
  }

  void _inputFinished(String text) {
    if (widget?.onSubmitted != null) {
      widget.onSubmitted(text);
    }
    if (widget?.onSubmittedWithLines != null) {
      widget.onSubmittedWithLines(text, _currentLineIndex);
    }
  }

  void _inputValueChanged(String text, int lineIndex, int height) {
    if (text != null) {
      if (_isMultiline &&
          _currentHeight != height &&
          widget.autoHeightMaxHeight > 0) {
        setState(() {
          _currentHeight = height;
        });
      }
      if (_isMultiline &&
          _currentLineIndex != lineIndex &&
          (lineIndex <= widget.maxLines || widget.maxLines == 0)) {
        setState(() {
          _currentLineIndex = lineIndex;
        });
      } else {
        _currentLineIndex = 0;
      }

      if (widget?.onChanged != null) widget.onChanged(text);
      if (widget?.onChangedWithLines != null)
        widget.onChangedWithLines(text, lineIndex);
      if (widget.controller != null) _effectiveController.text = text;
    }
  }

  static const Duration _caretAnimationDuration = Duration(milliseconds: 100);
  static const Curve _caretAnimationCurve = Curves.fastOutSlowIn;

  void _scrollIntoView() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.findRenderObject().showOnScreen(
            duration: _caretAnimationDuration,
            curve: _caretAnimationCurve,
          );
    });
  }
}
