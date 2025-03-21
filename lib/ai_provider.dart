import 'package:flutter/material.dart';

class AIProvider extends ChangeNotifier {
  String _responseText = "";

  String get responseText => _responseText;

  Future<void> generateResponse(String prompt) async {
    _responseText = "I understand your question about \"$prompt\". How can I assist you further?";
    notifyListeners();
  }

  void clearResponse() {
    _responseText = "";
    notifyListeners();
  }
}
