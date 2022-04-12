// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statefull/main.dart';
import 'package:statefull/router/Hadith.dart';

class EnterBook extends StatefulWidget {
  const EnterBook({
    Key? key,
    required String? this.book_key,
  }) : super(key: key);
  final String? book_key;

  @override
  _EnterBookState createState() => _EnterBookState();
}

class _EnterBookState extends State<EnterBook> {
  late Future<List> books;

  @override
  Future<List> getBooks(String? book_key) async {
    http.Response res =
        await http.get(Uri.parse("https://alquranbd.com/api/hadith/$book_key"));
    if (res.statusCode == 200) {
      //print(res.body);
      var x = jsonDecode(res.body);
      // print(x[0]);
      return x;
    } else {
      // print("error");
      throw Exception("error");
    }
  }

  @override
  void initState() {
    super.initState();
    this.books = getBooks(widget.book_key!);
    //print();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
          title: Center(child: Text("All Hadith")),
        ),
        body: Center(
          child: FutureBuilder(
              future: this.books,
              builder: (context, AsyncSnapshot<List> sn) {
                if (sn.hasData) {
                  List? finalBook = sn.data;
                  int ln = finalBook!.length;

                  String s = "01234567890/১২০৩৪৫৬৭৮৯";
                  for (int i = 0; i < ln; i++) {
                    String ss = "";
                    for (int j = 0;
                        j < finalBook[i]["nameBengali"].length;
                        j++) {
                      bool ok = false;
                      for (int k = 0; k < s.length; k++) {
                        if (finalBook[i]["nameBengali"][j] == s[k]) {
                          ok = true;
                          break;
                        }
                      }
                      if (ok) continue;
                      ss = ss.toString() + finalBook[i]["nameBengali"][j];
                    }
                    finalBook[i]["nameBengali"] = ss;

                    String bs = "";
                    for (int j = 0;
                        j < finalBook[i]["nameEnglish"].length;
                        j++) {
                      bool ok = false;
                      for (int k = 0; k < s.length; k++) {
                        if (finalBook[i]["nameEnglish"][j] == s[k]) {
                          ok = true;
                          break;
                        }
                      }
                      if (ok) continue;
                      bs = bs.toString() + finalBook[i]["nameEnglish"][j];
                    }
                    finalBook[i]["nameEnglish"] = bs;
                  }

                  return ListView.builder(
                    itemCount: ln,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => hadith(
                                  chapNo: finalBook[i]["chSerial"].toString(),
                                  book_key: widget.book_key)));
                        },
                        color: Colors.cyan.shade100,
                        hoverColor: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(finalBook[i]["chSerial"]),
                          ),
                          title: Text(finalBook[i]["nameBengali"]),
                          subtitle: Text(finalBook[i]["nameEnglish"]),
                          trailing: Text("Number Of Hadith: " +
                              finalBook[i]["hadith_number"] +
                              "\n" +
                              finalBook[i]["range_start"] +
                              " to " +
                              finalBook[i]["range_end"]),
                        ),
                      ),
                    ),
                  );
                } else if (sn.hasError) return Text("Error Loading Data...");
                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
