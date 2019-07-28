import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() async{
  List currencies = await getCurrencies();
  runApp(new MyApp(currencies));
}

class MyApp extends StatelessWidget {
  final List _currencies;
  MyApp(this._currencies);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crypto Stats",
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0)
      ),
      home: ListPage(_currencies),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListPage extends StatefulWidget {
  final List currencies;
  ListPage(this.currencies);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List currencies;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        centerTitle: true,
        title: Text("Crypto Stats", style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.currencies.length,
          itemBuilder: (BuildContext context, int index){
            final Map currency = widget.currencies[index];
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, 0.9)),
                child: getAllData(currency),
              ),
            );
          },
        ),
      ),
    );
  }
}

ListTile getAllData(Map currency){
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.white24))),
      child: Image.network("https://res.cloudinary.com/dxi90ksom/image/upload/" + currency["symbol"].toString().toLowerCase() + ".png"),
    ),
    title: Text(
      currency["name"],
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
    ),
    subtitle: Row(
      children: <Widget>[
        Text(
          currency["symbol"] + "(\$" + currency["price_usd"].toString().substring(0,7) + ")",
          style: TextStyle(color: Colors.white70),
        )
      ],
    ),
    trailing: Column(
      children: <Widget>[
        percent(currency["percent_change_1h"], currency["price_usd"].toString())
      ],
    ),
  );
}

Column percent(String percent, String usd){
  if(double.parse(percent) > 0){
    return Column(
      children: <Widget>[
        Icon(Icons.keyboard_arrow_up, color : Colors.white, size: 20.0),
        Text("(\$" + usd.substring(0,7) + ")", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(percent + "%", style: TextStyle(color:  Colors.greenAccent),),
        ],
    );
  }
  else {
    return Column(
      children: <Widget>[
        Icon(Icons.keyboard_arrow_down, color : Colors.white, size: 20.0),
        Text("(\$" + usd.substring(0,7) + ")", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(percent + "%", style: TextStyle(color:  Colors.redAccent),),
        ],
    );
  }
}

Future<List> getCurrencies() async{
  String url = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
  http.Response response = await http.get(url);
  return jsonDecode(response.body);
}