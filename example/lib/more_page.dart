import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'package:flutter_native_text_input_example/demo_item.dart';

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _changeTextController = TextEditingController();

  String _currentTextInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More Use Cases"),
      ),
      body: ListView(
        children: [
          DemoItem(title: "No Placeholder", child: NativeTextInput()),
          DemoItem(
              title: "Numeric Keyboard",
              child: Column(
                children: <Widget>[
                  NativeTextInput(
                    keyboardType: KeyboardType.decimalPad,
                  ),
                ],
              )),
          DemoItem(
              title: "Pre-Filling Text",
              child: NativeTextInput(
                controller: TextEditingController(text: "Text"),
              )),
          DemoItem(
            title: "Aligning Text to End",
            child: NativeTextInput(
              textAlign: TextAlign.end,
              controller: TextEditingController(text: "Text"),
            ),
          ),
          DemoItem(
              title: "Multiline Text Input",
              child: NativeTextInput(
                height: 72,
                maxLines: 0,
              )),
          DemoItem(
            title: "Displaying Input Value",
            child: Column(children: [
              NativeTextInput(
                placeholder: "Type something here",
                onChanged: (value) {
                  setState(() {
                    _currentTextInput = value;
                  });
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Input: '),
                  Expanded(child: Text(_currentTextInput)),
                ],
              )
            ]),
          ),
          DemoItem(
              title: "Focusing or Unfocusing Text Input",
              child: Column(
                children: [
                  FlatButton(
                      color: Colors.blue,
                      colorBrightness: Brightness.dark,
                      child: Text("Tap Me!"),
                      onPressed: () {
                        if (_focusNode.hasFocus) {
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(context).requestFocus(_focusNode);
                        }
                      }),
                  NativeTextInput(
                    focusNode: _focusNode,
                  )
                ],
              )),
          DemoItem(
              title: "Filling Text Programmatically",
              child: Column(
                children: [
                  FlatButton(
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text("Tap Me!"),
                    onPressed: () =>
                        _changeTextController.text = DateTime.now().toString(),
                  ),
                  NativeTextInput(
                    controller: _changeTextController,
                  )
                ],
              )),
          Padding(
            padding: EdgeInsets.all(100),
            child: Center(
                child: Column(children: [
              Text(
                'All done!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'Enjoy using in your way!',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              )
            ])),
          ),
        ],
      ),
    );
  }
}
