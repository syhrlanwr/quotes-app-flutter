import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quotes/constant.dart';
import 'package:quotes/quotes_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Quotes>> getQuotes() async {
    var url = Uri.https(Constant.BASE_URL, '/api/quote');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<Quotes> quotes = [];
      for (var item in json) {
        quotes.add(Quotes.fromJson(item));
      }

      return quotes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Quotes> getRandQuotes() async {
    var url = Uri.https(Constant.BASE_URL, '/api/quote/random');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Quotes.fromJson(json);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
