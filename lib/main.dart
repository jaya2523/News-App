import 'package:flutter/material.dart';
import 'package:news_app/views/home_screen.dart';

void main() {
  runApp(const Listview());
}

class Listview extends StatefulWidget {
  const Listview({Key? key}) : super(key: key);

  @override
  _ListviewState createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
  List<String> country = [
    "in",
    "us",
    "gb",
    "ca",
    "au",
  ];
  List<String> data = [
    "INDIA",
    "UNITED STATES",
    "UNITED KINGDOM",
    "CANADA",
    "AUSTRALIA",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country List',
          style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: country.length,
            itemBuilder: (context, pos) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListViewScreen(),
                      settings: RouteSettings(arguments: country[pos]),
                    ),
                  );
                },
                child: Card(
                  color: Colors.purple.shade100,
                  margin: EdgeInsets.all(15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text(
                      data[pos],
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
