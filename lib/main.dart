import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";

  Future<void> sendToGroqAI(String prompt) async {
    const String GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions";
    const String GROQ_API_KEY = "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"; // Replace with your actual API key

    final response = await http.post(
      Uri.parse(GROQ_API_URL),
      headers: {
        "Authorization": "Bearer $GROQ_API_KEY",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "model": "gemma2-9b-it",
        "messages": [
          {"role": "system", "content": "You are a financial analysis AI."},
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 500
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _result = jsonDecode(response.body)["choices"][0]["message"]["content"];
      });
    } else {
      setState(() {
        _result = "Error: ${response.statusCode}, ${response.body}";
      });
    }
  }

  void analyzeFinancialData() {
    String inputText = _controller.text.trim();
    if (inputText.isEmpty) {
      setState(() {
        _result = "Please enter financial data.";
      });
      return;
    }

    String finalPrompt = "Generate a detailed financial analysis for: $inputText";
    sendToGroqAI(finalPrompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildAssistantSection(),
            _buildFeaturesSection(),
            _buildCTASection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            "Neuro AI",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            "Our AI model analyzes financial data and provides valuable insights.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AI Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter financial data...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => _controller.clear(),
                  child: Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: analyzeFinancialData,
                  child: Text("Analyze"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(_result, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("Magical Capabilities", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("AI-powered financial insights, risk analysis, and trend prediction.",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(Icons.diamond, color: Colors.purple, size: 40),
            SizedBox(height: 10),
            Text("Ready to harness the power of AI?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[700])),
            SizedBox(height: 5),
            Text("Start using our AI model today to enhance your financial analysis.",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}