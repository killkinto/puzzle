import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Game',
          theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
      home: MyHomePage(title: 'Puzzle Game',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(child: Center(
        child: Text('No image selectted'),
      )),
      floatingActionButton: FloatingActionButton(onPressed: () => null,
      tooltip: 'New image', child: Icon(Icons.add),),
    );
  }
}
