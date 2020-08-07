import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_text_input/native_text_input.dart';
import 'package:flutter_native_text_input_example/demo_item.dart';

import 'more_page.dart';

class HomePage extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      body: ListView(
        children: <Widget>[
          DemoItem(
            title: 'TextField (from Flutter)',
            child: TextField(
              decoration: InputDecoration(
                hintText: 'placeholder',
                border: InputBorder.none,
              ),
            ),
          ),
          DemoItem(
            title: 'CupertinoTextField (from Flutter)',
            child: CupertinoTextField(
              placeholder: 'placeholder',
            ),
          ),
          DemoItem(
            title: 'Our NativeTextInput',
            child: NativeTextInput(
                placeholder: "placeholder",
                textContentType: TextContentType.password,
                keyboardType: KeyboardType.defaultType,
                inputValueChanged: (value) {
                  debugPrint("inputValueChanged: $value");
                },
                onSubmitted: (value) {
                  debugPrint("onSubmitted: $value");
                },
                focusNode: _focusNode),
          ),
          Center(
            child: FlatButton(
                color: Colors.blue,
                colorBrightness: Brightness.dark,
                child: Text("View More Use Cases"),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MorePage()));
                }),
          ),
        ],
      ),
    );
  }
}
