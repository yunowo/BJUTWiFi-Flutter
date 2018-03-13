import 'dart:async';

import 'package:http/http.dart' as http;
import 'entity.dart';
import 'util.dart';

const headers = {
  "Origin": "https://wlgn.bjut.edu.cn",
  "User-Agent":
      "Mozilla/5.0 (Linux; Android 7.1.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3131.0 Mobile Safari/537.36",
  "Accept": "application/json, text/javascript, */*; q=0.01",
  "Accept-Encoding": "gzip, deflate",
  "Accept-Language": "zh-CN,en-US;q=0.8",
  "X-Requested-With": "XMLHttpRequest",
};

login(username, password) {
  const url = "https://wlgn.bjut.edu.cn/";
  http.post(url, headers: headers, body: {
    "DDDDD": username,
    "upass": password,
    "R6": "1",
    "6MKKey": "123",
  }).then((response) {
    print(response.statusCode);
    print(response.body);
  });
}

logout() {
  const url = "https://wlgn.bjut.edu.cn/F.htm";
  http.get(url, headers: headers).then((response) {});
}

Future<Stats> getStats() {
  const url = "https://wlgn.bjut.edu.cn/1.htm";
  return http.get(url, headers: headers).then((response) {
    return parseStats(response.body);
  });
}
