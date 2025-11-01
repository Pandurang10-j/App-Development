import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "0";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void buttonPressed(String value) {
    setState(() {
      if (value == "CLEAR") {
        output = "0";
      } else if (value == "⌫") {
        if (output.length > 1) {
          output = output.substring(0, output.length - 1);
        } else {
          output = "0";
        }
      } else if (value == "=") {
        try {
          String expressionToEvaluate =
              output.replaceAll("×", "*").replaceAll("÷", "/");
          Parser p = Parser();
          Expression exp = p.parse(expressionToEvaluate);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          String result = eval.toString();

          _saveCalculation(expressionToEvaluate, result);
          output = result;
        } catch (e) {
          output = "Error";
        }
      } else if (value == "±") {
        if (output != "0" && output != "Error") {
          if (output.startsWith("-")) {
            output = output.substring(1);
          } else {
            output = "-$output";
          }
        }
      } else {
        if (output == "0" || output == "Error") {
          output = value;
        } else {
          output += value;
        }
      }
    });
  }

  Future<void> _saveCalculation(String expression, String result) async {
    try {
      await _firestore.collection('calculations').add({
        'expression': expression,
        'result': result,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving calculation: $e');
    }
  }

  Widget buildButton(String text, Color color, {double fontSize = 24}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 4,
          ),
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        title: const Text(
          "Calculator",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        backgroundColor: const Color(0xFF181A25),
        centerTitle: true,
        elevation: 6,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Output Display
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    output,
                    style: const TextStyle(
                        fontSize: 56,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // Buttons Section
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    children: [
                      buildButton("7", Colors.blueAccent),
                      buildButton("8", Colors.blueAccent),
                      buildButton("9", Colors.blueAccent),
                      buildButton("÷", Colors.orangeAccent),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("4", Colors.blueAccent),
                      buildButton("5", Colors.blueAccent),
                      buildButton("6", Colors.blueAccent),
                      buildButton("×", Colors.orangeAccent),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("1", Colors.blueAccent),
                      buildButton("2", Colors.blueAccent),
                      buildButton("3", Colors.blueAccent),
                      buildButton("-", Colors.orangeAccent),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("0", Colors.blueAccent),
                      buildButton("00", Colors.blueAccent),
                      buildButton(".", Colors.blueAccent),
                      buildButton("+", Colors.orangeAccent),
                    ],
                  ),
                  // Bottom row - CLEAR, ⌫, ±, =
                  Row(
                    children: [
                      buildButton("CLEAR", Colors.redAccent, fontSize: 18),
                      buildButton("⌫", Colors.grey, fontSize: 22),
                      buildButton("±", Colors.teal, fontSize: 22),
                      buildButton("=", Colors.green, fontSize: 26),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
