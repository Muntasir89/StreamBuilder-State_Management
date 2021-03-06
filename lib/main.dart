import 'dart:async';

import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Stream Tutorial'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late StreamController myStreamController = StreamController();
  late Stream myStream = myStreamController.stream;

  late StreamSubscription mySubs;

  int counter = 0;

  Stream<int> getDummyDownloadProgress() async*{
    for(int i=1;i<=100;i++){
      await Future.delayed(Duration(milliseconds: 100));
      yield i;
    }
    throw Exception(["Completed"]);
  }

  @override
  void initState(){
    //TODO: implement initState
    getDummyDownloadProgress().listen((event) {
      print(event);
      setState((){
        counter = event;
      });
    }, onError: (err){
      print(err);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("You have pushed the button this many times:"),
            StreamBuilder(
                stream: getDummyDownloadProgress(),
                builder: (_,snapshot){
                  if(snapshot.hasData)
                    return Text(snapshot.data.toString());
                  else if(snapshot.hasError)
                    return Text(snapshot.error.toString());
                  else
                    return Text("Loading");
                }),
          ],


        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          myStreamController.sink.add(counter);
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
