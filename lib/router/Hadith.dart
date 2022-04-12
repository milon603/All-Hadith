import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statefull/main.dart';
import 'package:statefull/router/EnterBook.dart';
import 'package:statefull/router/Hadith.dart';

class hadith extends StatefulWidget {
  const hadith({
    Key? key,
    required String? this.chapNo,
    required String? this.book_key,
  }) : super(key: key);
  final String? chapNo;
  final String? book_key;

  @override
  _hadithState createState() => _hadithState();
}

class _hadithState extends State<hadith> {
  late Future<List> hadith;

  Future<List> getBook(String? chaptNo, String? books_key) async {
    http.Response res = await http
        .get(Uri.parse("https://alquranbd.com/api/hadith/$books_key/$chaptNo"));
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
    this.hadith = getBook(widget.chapNo, widget.book_key);
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EnterBook(book_key: widget.book_key.toString())));
            },
          ),
          title: Center(child: Text("All Hadith")),
        ),
        body: Center(
          child: FutureBuilder(
              future: this.hadith,
              builder: (context, AsyncSnapshot<List> sn) {
                if (sn.hasData) {
                  List? finalBook = sn.data;
                  int ln = finalBook!.length;
                  for (int i = 0; i < ln; i++) {
                    String? s = "";
                    String ss =
                        "<>1234567890-=!@#%^&*_+`~qwertyuiop[]}{POIUYTREWQasdfghjkl;\|:LKJH'GFDSA\zxcvbnm,.%.,mnbvcxz\"";
                    for (int j = 0;
                        j < finalBook[i]["hadithBengali"].length;
                        j++) {
                      bool ok = false;
                      for (int k = 0; k < ss.length; k++) {
                        if (ss[k] == finalBook[i]["hadithBengali"][j]) {
                          ok = true;
                          // print("find");
                          break;
                        }
                      }
                      if (ok) continue;
                      s = s.toString() + finalBook[i]["hadithBengali"][j];
                      // int x =(char)finalBook[i]["hadithBengali"][j] - '0';
                      // print(s);
                    }
                    finalBook[i]["hadithBengali"] = s;
                  }
                  return ListView.builder(
                    itemCount: ln,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: () {},
                          color: Colors.cyan.shade100,
                          hoverColor: Colors.cyanAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "হাদীস নং : " + finalBook[i]["hadithNo"],
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                finalBook[i]["hadithArabic"],
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  height: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  finalBook[i]["hadithBengali"],
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          )),
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
