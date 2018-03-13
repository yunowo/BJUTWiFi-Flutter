import 'dart:async';

import 'package:bjut_wifi_flutter/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'entity.dart';
import 'about.dart';
import 'api.dart';

class Styles {
  static const TextStyle textBig = const TextStyle(fontSize: 20.0);
  static const TextStyle text = const TextStyle(fontSize: 14.0);
}

class WiFiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BJUT Wi-Fi Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{'/about': (BuildContext context) => AboutPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stats _stats = Stats(0, 0, 0);
  final formKey = new GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  int _package = 8;

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _password = prefs.getString('password') ?? '';
      _package = prefs.getInt('package') ?? 8;
    });
  }

  _setUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username);
    prefs.setString('password', _password);
    prefs.setInt('package', _package);
    await _getUser();
  }

  Future<Null> _updateStats() async {
    await _getUser();
    var stats = await getStats();
    print(stats);
    setState(() {
      _stats = stats;
    });
  }

  Future<Null> _openUserDialog() async {
    await _getUser();
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      child: AlertDialog(
        title: Text('用户'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _username,
                  decoration: InputDecoration(labelText: '用户名'),
                  validator: (val) => val.isEmpty ? 'Username can\'t be empty.' : null,
                  onSaved: (val) => _username = val,
                ),
                TextFormField(
                  initialValue: _password,
                  decoration: InputDecoration(labelText: '密码'),
                  validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                  onSaved: (val) => _password = val,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '套餐',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                DropdownButton<int>(
                  value: _package,
                  items: <DropdownMenuItem<int>>[
                    DropdownMenuItem<int>(
                      value: 8,
                      child: Text("8 GB"),
                    ),
                    DropdownMenuItem<int>(
                      value: 25,
                      child: Text("25 GB"),
                    ),
                    DropdownMenuItem<int>(
                      value: 30,
                      child: Text("30 GB"),
                    ),
                  ],
                  onChanged: (value) => _package = value,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              final form = formKey.currentState;
              if (form.validate()) {
                form.save();
                _setUser();
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text('BJUT Wi-Fi Flutter'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: _updateStats,
          ),
          PopupMenuButton<int>(
            onSelected: (item) {
              switch (item) {
                case 0:
                  _openUserDialog();
                  break;
                case 1:
                  Navigator.of(context).pushNamed('/about');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              var items = [0, 1];
              var options = ["用户", "关于"];
              return items
                  .map((choice) => PopupMenuItem<int>(
                        value: choice,
                        child: Text(options[choice]),
                      ))
                  .toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _updateStats,
        child: ListView(physics: AlwaysScrollableScrollPhysics(), children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              '$_username',
                              style: Styles.textBig,
                            ),
                            Text(
                              '已使用：${_stats.time} min',
                              style: Styles.text,
                            ),
                            Text(
                              '余额：${_stats.fee} RMB',
                              style: Styles.text,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    width: 60.0,
                                    margin: EdgeInsetsDirectional.only(top: 10.0),
                                    child: RaisedButton(
                                      onPressed: () => login(_username, _password),
                                      color: Theme.of(context).primaryColor,
                                      highlightColor: Theme.of(context).highlightColor,
                                      child: new Text(
                                        '登录',
                                        style: new TextStyle(color: Colors.white),
                                      ),
                                    )),
                                Container(
                                    width: 60.0,
                                    margin: EdgeInsetsDirectional.only(top: 10.0),
                                    child: RaisedButton(
                                      onPressed: logout,
                                      color: Theme.of(context).primaryColor,
                                      highlightColor: Theme.of(context).highlightColor,
                                      child: new Text(
                                        '注销',
                                        style: new TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                        ClipOval(
                          child: Container(
                            height: 120.0,
                            width: 120.0,
                            color: Theme.of(context).primaryColor,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 40.0,
                                  top: 45.0,
                                  child: Text(
                                    '${_stats.flow / _package / 1024 ~/ 10.24}%',
                                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                                Positioned(
                                  left: 35.0,
                                  bottom: 20.0,
                                  child: Text(
                                    '${formatSize(_stats.flow)}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FlutterLogo(size: 100.0),
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
