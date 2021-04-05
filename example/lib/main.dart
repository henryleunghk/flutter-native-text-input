import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'demo_item.dart';
import 'more_use_case_listing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  final NativeTextInputController _nativeTextInputController =
      NativeTextInputController();

  _onChangeText(value) => debugPrint("_onChangeText: $value");
  _onSubmittedText(value) => debugPrint("_onSubmittedText: $value");

  void _onChangeTextWithLines(String? text, int? linesCount) {
    debugPrint("_onChangeTextWithLines: $linesCount");
  }

  void _onSelectionChanged(String? text, int? position) {
    debugPrint("_onSelectionChanged: $text ; $position");
  }

  void _onSubmittedTextWithLines(String? text, int? linesCount) {
    debugPrint("_onSubmittedTextWithLines: $linesCount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      body: ListView(
        children: <Widget>[
          DemoItem(
              title: "Empty Text Programmatically",
              child: Column(
                children: [
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("colorText"),
                    onPressed: () {
                      print('_nativeTextInputController.colorText !!');
                      _nativeTextInputController
                          .colorText("@shay|@amit|@yaniv|@tomer");
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("emptyText"),
                    onPressed: () {
                      print('_nativeTextInputController.emptyText !!');
                      _nativeTextInputController.emptyText();
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("setText single"),
                    onPressed: () {
                      print('_nativeTextInputController.setText !!');
                      _nativeTextInputController.setText("shay dadosh");
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("setText multi"),
                    onPressed: () {
                      print('_nativeTextInputController.setText !!');
                      _nativeTextInputController
                          .setText("shay dadosh 1\nhello world 2\nline 3");
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("setText empty"),
                    onPressed: () {
                      print('_nativeTextInputController.setText !!');
                      _nativeTextInputController.setText("");
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("setText null"),
                    onPressed: () {
                      print('_nativeTextInputController.setText !!');
                      _nativeTextInputController.setText(null);
                    },
                  ),
                  NativeTextInput(
                    // textAlign: TextAlign.right,
                    autoHeightMaxLines: 5,
                    // autoHeightMaxHeight: 150,
                    minLines: 1,
                    maxLines: 0,
                    startText: 'hello',
                    placeholder: "type..",
                    placeholderTextAlign: TextAlign.left,
                    nativeTextInputController: _nativeTextInputController,
                    onChangedWithLines: _onChangeTextWithLines,
                    onSubmittedWithLines: _onSubmittedTextWithLines,
                    onSelectionChanged: _onSelectionChanged,
                    textColor: "redColor",
                    placeholderTextColor: "",
                    backgroundColor: "",
                    mentionTextColor: "greenColor",
                    // keyboardType: KeyboardType.asciiCapable,
                  )
                ],
              )),
          DemoItem(
            title: 'Flutter TextField Example Usage',
            child: TextField(
              onChanged: _onChangeText,
              onSubmitted: _onSubmittedText,
              autocorrect: true,
              decoration: InputDecoration(
                hintText: 'placeholder',
                border: InputBorder.none,
              ),
            ),
          ),
          DemoItem(
            title: 'Flutter CupertinoTextField Example Usage',
            child: CupertinoTextField(
              placeholder: 'placeholder',
              onChanged: _onChangeText,
              onSubmitted: _onSubmittedText,
            ),
          ),
          DemoItem(
            title: 'NativeTextInput Example Usage',
            child: Platform.isIOS
                ? NativeTextInput(
                    placeholder: "placeholder",
                    keyboardType: KeyboardType.defaultType,
                    onChanged: _onChangeText,
                    onSubmitted: _onSubmittedText,
                    focusNode: _focusNode)
                : TextField(
                    onChanged: _onChangeText,
                    onSubmitted: _onSubmittedText,
                    decoration: InputDecoration(
                      hintText: 'placeholder',
                      border: InputBorder.none,
                    ),
                  ),
          ),
          Center(
            child: FlatButton(
                color: Colors.blue,
                colorBrightness: Brightness.dark,
                child: Text("View More Use Cases"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MoreUseCaseListingPage()));
                }),
          ),
        ],
      ),
    );
  }
}
