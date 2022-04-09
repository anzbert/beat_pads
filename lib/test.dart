import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Listener(
            onPointerDown: (deets) => print("down"),
            onPointerUp: (deets) => print("up"),
            child: Material(
              color: Colors.green,
              child: InkWell(
                onTapDown: (_) {
                  // onTapUp: (deets) => print("up"),
                  // onTapCancel: (_) => print("cancel"),
                  // print("down");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Test2 extends StatelessWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Material(
            color: Colors.green,
            child: InkWell(
              onTapDown: (details) => print("down $details"),
              onTapUp: (details) => print("up $details"),
              onTapCancel: () => print("cancel"),
            ),
          ),
        ),
      ),
    );
  }
}

class Test3 extends StatelessWidget {
  const Test3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: ElevatedButton(
            // color: Colors.green,
            onPressed: () => print("down"),
            child: Text("test3"),
            // onTapUp: (details) => print("up $details"),
            // onTapCancel: () => print("cancel"),
          ),
        ),
      ),
    );
  }
}
