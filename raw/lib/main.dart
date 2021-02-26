import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FocusNode incnode;
  FocusNode decnode;
  @override
  void initState() {
    super.initState();
    incnode = new FocusNode();
    decnode = new FocusNode();
   
  }

  void _incrementCounter() {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('increment'),
          duration: const Duration(milliseconds: 400),
        ),
      );
      FocusScope.of(context).requestFocus(incnode);

      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('decrement'),
          duration: const Duration(milliseconds: 400),
        ),
      );
      FocusScope.of(context).requestFocus(decnode);

      _counter--;
    });
  }
  @override
  void dispose() {
    incnode.dispose();
    decnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CounterShortcuts(
      onIncrementDetected: _incrementCounter,
      onDecrementDetected: _decrementCounter,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                focusNode: decnode,
                focusColor: Colors.black,
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                child: Icon(Icons.remove),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                focusNode: incnode,
                focusColor: Colors.black,
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ],
          )),
    );
  }
}

final incrementKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowUp,
);
final decrementKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowDown,
);

class IncrementIntent extends Intent {}

class DecrementIntent extends Intent {}

class CounterShortcuts extends StatelessWidget {
  const CounterShortcuts({
    Key key,
    @required this.child,
    @required this.onIncrementDetected,
    @required this.onDecrementDetected,
  }) : super(key: key);
  final Widget child;

  final VoidCallback onIncrementDetected;
  final VoidCallback onDecrementDetected;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        incrementKeySet: IncrementIntent(),
        decrementKeySet: DecrementIntent(),
      },
      actions: {
        IncrementIntent:
            CallbackAction(onInvoke: (e) => onIncrementDetected?.call()),
        DecrementIntent:
            CallbackAction(onInvoke: (e) => onDecrementDetected?.call()),
      },
      child: child,
    );
  }
}
