import 'package:binder/binder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BinderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

final counterRef = StateRef(0);

/// A [LogicRef] declares a business logic component, which is able to mutate
/// the app state.
final counterViewLogicRef = LogicRef((scope) => CounterViewLogic(scope));

/// A business logic component can apply the [Logic] mixin to have access to
/// useful methods, such as `write` and `read`.
class CounterViewLogic with Logic {
  const CounterViewLogic(this.scope);

  /// This is the object which is able to interact with other components.
  @override
  final Scope scope;

  /// We can use the [write] method to mutate the state referenced by a
  /// [StateRef] and [read] to obtain its current state.
  void increment() => write(counterRef, read(counterRef) + 1);
  void decrement() => write(counterRef, read(counterRef) - 1);
}

class MyHomePage extends StatelessWidget {
  final String? title;
  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch(counterRef);
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text('$counter', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.use(counterViewLogicRef).decrement(),
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () => context.use(counterViewLogicRef).increment(),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
