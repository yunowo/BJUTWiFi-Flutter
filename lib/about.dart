import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static const gitHubUrl = 'https://github.com/yunv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.wifi_lock),
            title: Text('BJUT Wi-Fi'),
            subtitle: Text('Flutter Edition'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('0.1.0'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Source code'),
            subtitle: Text(gitHubUrl),
            onTap: () async {
              if (await canLaunch(gitHubUrl)) {
                await launch(gitHubUrl);
              } else {
                throw 'Could not launch $gitHubUrl';
              }
            },
          ),
        ],
      ),
      //body:Text('fff'),
    );
  }
}
