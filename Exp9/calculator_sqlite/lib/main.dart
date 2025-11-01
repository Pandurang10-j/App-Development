import 'package:flutter/material.dart';
import 'dp_helper.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const CalculatorScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calculator"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '';

  void _buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _input = '';
        _result = '';
      } else if (text == '=') {
        try {
          final expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
          _result = _evaluate(expression).toString();
          DatabaseHelper.instance.insertHistory('$_input = $_result');
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _input += text;
      }
    });
  }

  double _evaluate(String exp) {
  try {
    // Replace symbols with Dart operators
    exp = exp.replaceAll('×', '*').replaceAll('÷', '/');

    // Use a stack-based evaluator (handles +, -, *, /)
    List<String> tokens = _tokenize(exp);
    List<double> values = [];
    List<String> ops = [];

    for (String token in tokens) {
      if (_isNumber(token)) {
        values.add(double.parse(token));
      } else if (_isOperator(token)) {
        while (ops.isNotEmpty && _precedence(ops.last) >= _precedence(token)) {
          double b = values.removeLast();
          double a = values.removeLast();
          String op = ops.removeLast();
          values.add(_applyOp(a, b, op));
        }
        ops.add(token);
      }
    }

    while (ops.isNotEmpty) {
      double b = values.removeLast();
      double a = values.removeLast();
      String op = ops.removeLast();
      values.add(_applyOp(a, b, op));
    }

    return values.last;
  } catch (e) {
    return double.nan;
  }
}

// --- helper functions ---
List<String> _tokenize(String exp) {
  final regex = RegExp(r'(\d+\.\d+|\d+|[+\-*/])');
  return regex.allMatches(exp).map((m) => m.group(0)!).toList();
}

bool _isNumber(String s) => double.tryParse(s) != null;

bool _isOperator(String s) => ['+', '-', '*', '/'].contains(s);

int _precedence(String op) {
  if (op == '+' || op == '-') return 1;
  if (op == '*' || op == '/') return 2;
  return 0;
}

double _applyOp(double a, double b, String op) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return b != 0 ? a / b : double.nan;
    default:
      return 0;
  }
}


  final List<String> buttons = [
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
    'C'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _input,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  final btn = buttons[index];
                  final isOperator = ['÷', '×', '-', '+', '='].contains(btn);
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator ? Colors.orangeAccent : Colors.white,
                      foregroundColor: isOperator ? Colors.white : Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(8),
                      elevation: 5,
                    ),
                    onPressed: () => _buttonPressed(btn),
                    child: Text(
                      btn,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final data = await DatabaseHelper.instance.getHistory();
    setState(() => _history = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculation History")),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(item['expression']),
          );
        },
      ),
    );
  }
}
