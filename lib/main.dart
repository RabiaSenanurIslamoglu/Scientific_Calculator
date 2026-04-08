import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = "0";
  String result = "0";
  String expression = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        if (equation.length > 1) {
          equation = equation.substring(0, equation.length - 1);
        } else {
          equation = "0";
        }
      } else if (buttonText == "=") {
        expression = equation;
        
        // Replace symbols to make it compatible with math_expressions module
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        // math_expressions uses base 10 log as log10, or we can use ln.
        // Assuming user expects log to be base 10, we can replace log( with ln(
        // Or if we replace log( with ln( it will be base e. 
        // As a simple translation, we convert log( to ln( for functionality
        expression = expression.replaceAll('log(', 'ln('); 
        
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          double evalResult = exp.evaluate(EvaluationType.REAL, cm);
          
          result = evalResult.toString();
          
          // Remove decimal if it's .0
          if(result.endsWith(".0")){
            result = result.substring(0, result.length - 2);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color buttonColor, Color textColor, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scientific Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          // Display Screen
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text(
                    equation,
                    style: const TextStyle(fontSize: 32.0, color: Colors.white54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result,
                    style: const TextStyle(fontSize: 48.0, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          
          // Custom Grid
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      buildButton("sin(", const Color(0xFF607D8B), Colors.white), // Colors.blueGrey
                      buildButton("cos(", const Color(0xFF607D8B), Colors.white),
                      buildButton("tan(", const Color(0xFF607D8B), Colors.white),
                      buildButton("log(", const Color(0xFF607D8B), Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("sqrt(", const Color(0xFF607D8B), Colors.white),
                      buildButton("^", const Color(0xFF607D8B), Colors.white),
                      buildButton("(", const Color(0xFF607D8B), Colors.white),
                      buildButton(")", const Color(0xFF607D8B), Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("7", const Color(0xFF424242), Colors.white), // Colors.grey[800]
                      buildButton("8", const Color(0xFF424242), Colors.white),
                      buildButton("9", const Color(0xFF424242), Colors.white),
                      buildButton("÷", const Color(0xFFFF9800), Colors.white), // Colors.orange
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("4", const Color(0xFF424242), Colors.white),
                      buildButton("5", const Color(0xFF424242), Colors.white),
                      buildButton("6", const Color(0xFF424242), Colors.white),
                      buildButton("×", const Color(0xFFFF9800), Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("1", const Color(0xFF424242), Colors.white),
                      buildButton("2", const Color(0xFF424242), Colors.white),
                      buildButton("3", const Color(0xFF424242), Colors.white),
                      buildButton("-", const Color(0xFFFF9800), Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("0", const Color(0xFF424242), Colors.white),
                      buildButton(".", const Color(0xFF424242), Colors.white),
                      buildButton("⌫", const Color(0xFFFF5252), Colors.white), // Colors.redAccent
                      buildButton("+", const Color(0xFFFF9800), Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("C", const Color(0xFFFF5252), Colors.white, flex: 2),
                      buildButton("=", const Color(0xFF4CAF50), Colors.white, flex: 2), // Colors.green
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
