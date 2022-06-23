import 'package:flutter/material.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'package:flutter_native_text_input_example/demo_item.dart';

class MoreUseCaseListingPage extends StatefulWidget {
  const MoreUseCaseListingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoreUseCaseListingPageState();
}

class _MoreUseCaseListingPageState extends State<MoreUseCaseListingPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _changeTextController = TextEditingController();

  String _currentTextInput = '';

  _onChangeText(value) => debugPrint("_onChangeText: $value");
  _onSubmittedText(value) => debugPrint("_onSubmittedText: $value");
  _onTap(BuildContext context) {
    const snackBar = SnackBar(content: Text('Tapped!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("More Use Cases"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DemoItem(
                  title: "No Placeholder",
                  child: NativeTextInput(
                    onChanged: _onChangeText,
                    onSubmitted: _onSubmittedText,
                  )),
              DemoItem(
                  title: "Custom font",
                  child: NativeTextInput(
                    style: const TextStyle(
                      fontFamily: 'Noteworthy',
                    ),
                    placeholder: 'Noteworthy',
                    iosOptions: IosOptions(
                      placeholderStyle: const TextStyle(
                        fontFamily: 'Noteworthy',
                      ),
                    ),
                  )),
              DemoItem(
                  title: "Numeric Keyboard",
                  child: Column(
                    children: <Widget>[
                      NativeTextInput(
                        keyboardType: KeyboardType.decimalPad,
                        onChanged: _onChangeText,
                        onSubmitted: _onSubmittedText,
                      ),
                    ],
                  )),
              DemoItem(
                  title: "Pre-Filling Text",
                  child: NativeTextInput(
                    controller: TextEditingController(text: "Text"),
                    onChanged: _onChangeText,
                    onSubmitted: _onSubmittedText,
                  )),
              DemoItem(
                title: "Aligning Text to End",
                child: NativeTextInput(
                  textAlign: TextAlign.end,
                  controller: TextEditingController(text: "Text"),
                  onChanged: _onChangeText,
                  onSubmitted: _onSubmittedText,
                ),
              ),
              DemoItem(
                  title: "Multiline Text Input",
                  child: NativeTextInput(
                    minLines: 3,
                    maxLines: 5,
                    returnKeyType: ReturnKeyType.defaultAction,
                    onChanged: _onChangeText,
                    onSubmitted: _onSubmittedText,
                  )),
              DemoItem(
                title: "Displaying Input Value",
                child: Column(children: [
                  NativeTextInput(
                    placeholder: "Type something here",
                    onChanged: (value) {
                      _onChangeText(value);
                      setState(() {
                        _currentTextInput = value;
                      });
                    },
                    onSubmitted: _onSubmittedText,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Input: '),
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
                          child: const Text("Tap Me!"),
                          onPressed: () {
                            if (_focusNode.hasFocus) {
                              FocusScope.of(context).unfocus();
                            } else {
                              FocusScope.of(context).requestFocus(_focusNode);
                            }
                          }),
                      NativeTextInput(
                        focusNode: _focusNode,
                        onChanged: _onChangeText,
                        onSubmitted: _onSubmittedText,
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
                        child: const Text("Tap Me!"),
                        onPressed: () => _changeTextController.text =
                            DateTime.now().toString(),
                      ),
                      NativeTextInput(
                        controller: _changeTextController,
                        onChanged: _onChangeText,
                        onSubmitted: _onSubmittedText,
                      )
                    ],
                  )),
              DemoItem(
                  title: "Recognizing Tap",
                  child: NativeTextInput(
                    onTap: () => _onTap(context),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(100),
                child: Center(
                    child: Column(children: const [
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
        ));
  }
}
