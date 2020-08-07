import 'package:flutter/material.dart';

class DemoItem extends StatelessWidget {
  final String title;
  final Widget child;

  DemoItem({
    this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                color: Colors.black12,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(title),
                  )
                ])),
            Padding(padding: EdgeInsets.all(8), child: child),
          ],
        ));
  }
}
