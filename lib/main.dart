import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //This allows us to convert the returned JSON data into something Dart can use.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

// Since we're returning a Future, we must set our function to type Future.
Future GetCountry(country) {
  String countryUrl = 'https://restcountries.eu/rest/v2/name/taiwan';
  http
      .get(countryUrl)
      .then((response) => jsonDecode(response.body)[0]['name'])
      .then((decoded) => print(decoded))
      .catchError((error) => throw (error));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _ipAddress = '';
  var _userProfilelist = '';
  var _ub = userBo;
  final _TextControlTitle = TextEditingController();
  final _TextControlName = TextEditingController();
  final _TextControlPwd = TextEditingController();

  _getUserProfileList() async {
    var url = 'http://jnss1980.asuscomm.com:5000/getUserProfileList';
    String result;
    userBo o;
    final response = await http.get(url);
    Utf8Decoder decode = new Utf8Decoder();

    if (response.statusCode == 200) {
      result = "";
      //var z = jsonDecode(utf8.decode(response.bodyBytes));
      final Map<String, dynamic> responseMap =
          jsonDecode(utf8.decode(response.bodyBytes));

      List<userBo> o = new List<userBo>();
      for (dynamic z in responseMap["data"]) {
        // o.add(new userBo(
        //     user_ID: z[0].toString(),
        //     user_title: z[1].toString(),
        //     user_name: z[2].toString(),
        //     user_pwd: z[3].toString(),
        //     user_phone: z[4].toString(),
        //     RecordTime: z[5].toString()));

        result += "user_ID:" +
            z[0].toString() +
            ",user_title:" +
            z[1].toString() +
            ",user_name:" +
            z[2].toString() +
            ",user_pwd:" +
            z[3].toString() ;
      }

      /*
       command = "CREATE TABLE UserProfile(\
            user_ID Text Not NULL,\
            user_title Text NULL,\
            user_name Text NULL,\
            user_pwd Text NULL,\
            user_phone TEXT NULL,\
            RecordTime Text NOT Null,\
            PRIMARY KEY (user_ID, RecordTime)
       */

      // result = "user_title:" +
      //     o.user_title +
      //     ",user_name:" +
      //     o.user_name +
      //     ",user_pwd:" +
      //     o.user_pwd +
      //     ",Server IP:" +
      //     o.user_remote_addr;
    }

    if (!mounted) return;

    setState(() {
      _ipAddress = result;
      //_ub = o as Type;
    });
  }

  _getIPAddress() async {
    var url = 'http://jnss1980.asuscomm.com:5000/';
    //var url = 'https://httpbin.org/ip';
    // var httpClient = new HttpClient();
    // print('run 1');
    String result;
    userBo o;
    // try {
    //   var request = await httpClient.getUrl(Uri.parse(url));
    //   request.headers.add('Content-type', 'application/json; charset=UTF-8');
    //   request.add(utf8.encode(
    //       jsonEncode({'user_name': 'lee rochen', 'user_pwd': 'elevenjj'})));
    //   var response = await request.close();
    //   if (response.statusCode == HttpStatus.ok) {
    //     var json = await response.transform(utf8.decoder).join();
    //     // var data = jsonDecode(json);
    //     //result = data['origin'];
    //     result = json;
    //   } else {
    //     result = 'Err getting IP address ';
    //   }
    // } catch (exception) {
    //   print(exception);
    //   result = 'Failed getting IP address';
    // }

    var response = await http.post(url,
        headers: {'Content-type': 'application/json; charset=UTF-8'},
        body: utf8.encode(jsonEncode({
          'user_title': _TextControlTitle.text,
          'user_name': _TextControlName.text,
          'user_pwd': _TextControlPwd.text,
        })));
    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    Utf8Decoder decode = new Utf8Decoder();
    result = response.body;

    o = userBo.fromJson(jsonDecode(response.body));
    result = "user_ID:" +
        o.user_ID +
        ",user_title:" +
        o.user_title +
        ",user_name:" +
        o.user_name +
        ",user_pwd:" +
        o.user_pwd +
        ",Server IP:" +
        o.user_remote_addr;
    if (!mounted) return;

    setState(() {
      _ipAddress = result;
      //_ub = o as Type;
    });
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    void _textFieldChanged(String str) {
      print(str);
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text("網路測試APP"),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 4.0,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Icon(Icons.map),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: new Text("Yout Get Word !!"),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
            ),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 4.0,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Icon(Icons.map),
                  new Text("稱號:"),
                  Container(
                    width: 200,
                    height: 50,
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      onChanged: _textFieldChanged,
                      controller: _TextControlTitle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 4.0,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Icon(Icons.map),
                  new Text("名稱:"),
                  Container(
                    width: 200,
                    height: 50,
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      onChanged: _textFieldChanged,
                      controller: _TextControlName,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 4.0,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Icon(Icons.map),
                  new Text("密碼:"),
                  Container(
                    width: 200,
                    height: 50,
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      onChanged: _textFieldChanged,
                      controller: _TextControlPwd,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              width: 300,
              height: 70,
              child: new Text(
                '$_ipAddress.',
                textAlign: TextAlign.left,
              ),
            ),
            spacer,
            new RaisedButton(
              onPressed: _getIPAddress,
              child: new Text('取得網路資訊 !!'),
            ),
            new RaisedButton(
              onPressed: _getUserProfileList,
              child: new Text("取得使用者清單"),
            )
          ],
        ),
      ),
    );
  }
}


class userBo {
  final String user_ID;
  final String user_title;
  final String user_name;
  final String user_pwd;
  final String user_phone;
  final String user_remote_addr;
  final String RecordTime;

  userBo(
      {this.user_ID,
      this.user_title,
      this.user_name,
      this.user_pwd,
      this.user_phone,
      this.user_remote_addr,
      this.RecordTime});

  factory userBo.fromJson(Map<String, dynamic> json) {
    return userBo(
      user_ID: json['user_ID'] as String,
      user_title: json['user_title'] as String,
      user_name: json['user_name'] as String,
      user_pwd: json['user_pwd'] as String,
      user_phone: json['user_phone'] as String,
      user_remote_addr: json['user_remote_addr'] as String,
      RecordTime: json['RecordTime'] as String,
    );
  }
}
