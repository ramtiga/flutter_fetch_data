import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'model/user.dart';

List<User> parseUsers(String responseBody) {
  var list = json.decode(responseBody)['results'] as List<dynamic>;
  List<User> users = list.map((model) => User.fromJson(model)).toList();
  return users;
}

Future<List<User>> fetchUsers() async {
  final response = await http.get("https://randomuser.me/api/?results=20");
  if (response.statusCode == 200) {
    return compute(parseUsers, response.body);
  } else {
    throw Exception('Can\'t get users');
  }
}
