import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CurrencyInputScreen(),
    );
  }
}

class CurrencyInputScreen extends StatefulWidget {
  @override
  _CurrencyInputScreenState createState() => _CurrencyInputScreenState();
}

class _CurrencyInputScreenState extends State<CurrencyInputScreen> {
  final TextEditingController usdController = TextEditingController();
  final TextEditingController cadController = TextEditingController();
  double exchangeRate = 1.35; // Default exchange rate (will update dynamically)

  @override
  void initState() {
    super.initState();
    fetchExchangeRate(); // Fetch the latest exchange rate when the screen loads
  }

  // Function to fetch exchange rate from the API
  Future<void> fetchExchangeRate() async {
    final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));

    if (response.statusCode == 200) {
      setState(() {
        exchangeRate = jsonDecode(response.body)['rates']['CAD']; // Update exchange rate
      });
    } else {
      // If API call fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch exchange rate")),
      );
    }
  }

  void _convertUsdToCad(String value) {
    if (value.isEmpty) {
      cadController.clear();
      return;
    }
    try {
      double usd = double.parse(value);
      double cad = usd * exchangeRate;
      cadController.text = cad.toStringAsFixed(2);
    } catch (e) {
      cadController.clear();
    }
  }

  void _convertCadToUsd(String value) {
    if (value.isEmpty) {
      usdController.clear();
      return;
    }
    try {
      double cad = double.parse(value);
      double usd = cad / exchangeRate;
      usdController.text = usd.toStringAsFixed(2);
    } catch (e) {
      usdController.clear();
    }
  }

  void _navigateToSummaryScreen() {
    if (usdController.text.isEmpty && cadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a value")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversionSummaryScreen(
          usdAmount: usdController.text,
          cadAmount: cadController.text,
          exchangeRate: exchangeRate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Converter')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Exchange Rate: 1 USD = ${exchangeRate.toStringAsFixed(2)} CAD",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextFormField(
              controller: usdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'USD'),
              onChanged: _convertUsdToCad,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: cadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'CAD'),
              onChanged: _convertCadToUsd,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _navigateToSummaryScreen,
              child: Text('View Summary'),
            ),
          ],
        ),
      ),
    );
  }
}


class ConversionSummaryScreen extends StatelessWidget {
  final String usdAmount;
  final String cadAmount;
  final double exchangeRate;

  const ConversionSummaryScreen({
    required this.usdAmount,
    required this.cadAmount,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversion Summary')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("USD: \$${usdAmount.isEmpty ? '0' : usdAmount}", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text("CAD: \$${cadAmount.isEmpty ? '0' : cadAmount}", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text("Exchange Rate: 1 USD = $exchangeRate CAD", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Converter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
