import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quotes/quotes_model.dart';
import 'package:quotes/quotes_page.dart';

import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Wise Words'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Quotes? quotes;

  @override
  void initState() {
    super.initState();
    getRandQuotes();
  }

  void getRandQuotes() async {
    var quotes = await ApiService.getRandQuotes();
    setState(() {
      this.quotes = quotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 183, 229),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: quotes != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    width: 250,
                    height: 250,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quotes!.quote,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '- ${quotes!.author}',
                    style: const TextStyle(
                        fontSize: 20, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        getRandQuotes();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(249, 133, 28, 6),
                    ),
                    child: const Text('Shuffle'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuotesPage(
                            title: 'Words',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(249, 133, 28, 6),
                    ),
                    child: const Text('Show More'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
