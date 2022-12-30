import 'package:flutter/material.dart';
import 'package:quotes/api_service.dart';
import 'package:quotes/constant.dart';
import 'package:quotes/quotes_model.dart';
import 'package:http/http.dart' as http;

class QuotesPage extends StatefulWidget {
  QuotesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List<Quotes> quotes = [];

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  void getQuotes() async {
    var quotes = await ApiService.getQuotes();
    setState(() {
      this.quotes = quotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 183, 229),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                showAddDialog();
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: (quotes.length > 0)
          ? ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(quotes[index].quote,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('-  ${quotes[index].author}',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                  onLongPress: () {
                    deleteDialog(quotes[index]);
                  },
                  onTap: () {
                    showEditDialog(quotes[index]);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void deleteDialog(Quotes quot) {
    final passwordController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Quote'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to delete this words?'),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Type password to confirm',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteQuote(quot, passwordController.text);
                  },
                  child: Text('Delete')),
            ],
          );
        });
  }

  void deleteQuote(Quotes quot, String password) async {
    int id = quot.id;
    var url = Uri.https(Constant.BASE_URL, 'api/quote/delete/$id');
    debugPrint(url.toString());
    var response = await http.post(url, body: {'password': password});

    debugPrint(response.body);

    if (response.statusCode == 200) {
      setState(() {
        quotes.remove(quot);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Words deleted'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete Words'),
        ),
      );
    }
  }

  void showAddDialog() {
    final quoteController = TextEditingController();
    final authorController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Quote'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quoteController,
                  decoration: InputDecoration(
                    hintText: 'Quote',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(
                    hintText: 'Author',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    addQuote(quoteController.text, authorController.text,
                        passwordController.text);
                  },
                  child: Text('Add')),
            ],
          );
        });
  }

  void addQuote(String quote, String author, String password) async {
    var url = Uri.https(Constant.BASE_URL, 'api/quote');
    debugPrint(url.toString());
    var response = await http.post(url, body: {
      'quote': quote,
      'author': author,
      'password': password,
    });

    debugPrint(response.body);

    if (response.statusCode == 200) {
      getQuotes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote added'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add quote'),
        ),
      );
    }
  }

  void showEditDialog(Quotes quot) {
    final quoteController = TextEditingController();
    final authorController = TextEditingController();
    final passwordController = TextEditingController();

    quoteController.text = quot.quote;
    authorController.text = quot.author;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Quote'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quoteController,
                  decoration: InputDecoration(
                    hintText: 'Quote',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(
                    hintText: 'Author',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration:
                      InputDecoration(hintText: 'Type password to confirm'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    editQuote(quot, quoteController.text, authorController.text,
                        passwordController.text);
                  },
                  child: Text('Edit')),
            ],
          );
        });
  }

  void editQuote(
      Quotes quot, String quote, String author, String password) async {
    int id = quot.id;
    var url = Uri.https(Constant.BASE_URL, 'api/quote/edit/$id');
    debugPrint(url.toString());
    var response = await http.post(url, body: {
      'quote': quote,
      'author': author,
      'password': password,
    });

    debugPrint(response.body);

    if (response.statusCode == 200) {
      getQuotes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote edited'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to edit quote'),
        ),
      );
    }
  }
}
