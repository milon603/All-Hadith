import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statefull/router/EnterBook.dart';

import 'cilpper/HomeClipper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List> book;

  @override
  Future<List> getBooks() async {
    http.Response res =
        await http.get(Uri.parse("https://alquranbd.com/api/hadith"));
    return jsonDecode(res.body);
  }

  @override
  void initState() {
    super.initState();
    this.book = getBooks();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('All Hadih')),
        ),
        body: Center(
          child: Container(
            child: FutureBuilder(
              future: this.book,
              builder: (context, AsyncSnapshot<List> mySnapshot) {
                if (mySnapshot.hasData) {
                  List? books = mySnapshot.data;
                  return ListView.builder(
                    itemCount: books!.length,
                    itemBuilder: (BuildContext context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.cyanAccent,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.5,
                                    child: ClipPath(
                                      child: Container(
                                        color: Colors.deepOrangeAccent,
                                        height: 250,
                                        width: double.infinity,
                                      ),
                                      clipper: MyClipper(),
                                    ),
                                  ),
                                  ClipPath(
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => EnterBook(
                                                    book_key: books[i]
                                                            ["book_key"]
                                                        .toString())));
                                      },
                                      child: Container(
                                        height: 230,
                                        width: double.infinity,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            child: Text(books[i]["id"]),
                                          ),
                                          title: Text(books[i]["nameBengali"]),
                                          subtitle:
                                              Text(books[i]["nameEnglish"]),
                                          trailing: Text("Number Of Hadith: " +
                                              books[i]["hadith_number"]),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    clipper: MyClipper(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (mySnapshot.hasError)
                  return Text("Error Loading Data...");
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
