import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'package:flutter_native_text_input_example/demo_item.dart';
import 'package:flutter_native_text_input_example/more_use_case_listing_page.dart';

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

  _onChangeText(value) => debugPrint("_onChangeText: $value");
  _onSubmittedText(value) => debugPrint("_onSubmittedText: $value");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      body: ListView(
        children: <Widget>[
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
              cursorColor: Colors.black87,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black87,
                  width: 2,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textCapitalization: TextCapitalization.sentences,
              placeholderStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black12,
              ),
              placeholder: 'placeholder',
              onChanged: _onChangeText,
              onSubmitted: _onSubmittedText,
            ),
          ),
          DemoItem(
            title: 'NativeTextInput Example Usage',
            child: NativeTextInput(
              cursorColor: Colors.black87,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black87,
                  width: 2,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textCapitalization: TextCapitalization.sentences,
              placeholderStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black12,
              ),
              placeholder: "placeholder",
              keyboardAppearance: Brightness.dark,
              keyboardType: KeyboardType.defaultType,
              onChanged: _onChangeText,
              onSubmitted: _onSubmittedText,
              focusNode: _focusNode,
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
