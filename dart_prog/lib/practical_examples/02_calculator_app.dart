import 'package:flutter/material.dart';

// Aplikasi Kalkulator Sederhana
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '0';
  String _previousNumber = '';
  String _operation = '';
  bool _waitingForOperand = false;

  void _inputNumber(String number) {
    setState(() {
      if (_waitingForOperand) {
        _display = number;
        _waitingForOperand = false;
      } else {
        _display = _display == '0' ? number : _display + number;
      }
    });
  }

  void _inputOperation(String nextOperation) {
    double inputValue = double.parse(_display);

    if (_previousNumber.isEmpty) {
      _previousNumber = inputValue.toString();
    } else if (_operation.isNotEmpty) {
      double previousValue = double.parse(_previousNumber);
      double result = _calculate(previousValue, inputValue, _operation);
      
      setState(() {
        _display = _formatNumber(result);
        _previousNumber = result.toString();
      });
    }

    setState(() {
      _waitingForOperand = true;
      _operation = nextOperation;
    });
  }

  double _calculate(double firstOperand, double secondOperand, String operation) {
    switch (operation) {
      case '+':
        return firstOperand + secondOperand;
      case '-':
        return firstOperand - secondOperand;
      case '×':
        return firstOperand * secondOperand;
      case '÷':
        return secondOperand != 0 ? firstOperand / secondOperand : 0;
      default:
        return secondOperand;
    }
  }

  void _performCalculation() {
    double inputValue = double.parse(_display);

    if (_previousNumber.isNotEmpty && _operation.isNotEmpty) {
      double previousValue = double.parse(_previousNumber);
      double result = _calculate(previousValue, inputValue, _operation);
      
      setState(() {
        _display = _formatNumber(result);
        _previousNumber = '';
        _operation = '';
        _waitingForOperand = true;
      });
    }
  }

  void _clear() {
    setState(() {
      _display = '0';
      _previousNumber = '';
      _operation = '';
      _waitingForOperand = false;
    });
  }

  void _clearEntry() {
    setState(() {
      _display = '0';
    });
  }

  void _inputDecimal() {
    if (_waitingForOperand) {
      setState(() {
        _display = '0.';
        _waitingForOperand = false;
      });
    } else if (!_display.contains('.')) {
      setState(() {
        _display = _display + '.';
      });
    }
  }

  void _toggleSign() {
    if (_display != '0') {
      setState(() {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-' + _display;
        }
      });
    }
  }

  void _percentage() {
    double value = double.parse(_display);
    setState(() {
      _display = _formatNumber(value / 100);
    });
  }

  String _formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_operation.isNotEmpty)
                      Text(
                        '$_previousNumber $_operation',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      _display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            // Buttons
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Row 1: Clear, +/-, %, ÷
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', _clear, Colors.grey[300]!, Colors.black),
                          _buildButton('CE', _clearEntry, Colors.grey[300]!, Colors.black),
                          _buildButton('±', _toggleSign, Colors.grey[300]!, Colors.black),
                          _buildButton('÷', () => _inputOperation('÷'), Colors.orange, Colors.white),
                        ],
                      ),
                    ),
                    
                    // Row 2: 7, 8, 9, ×
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7', () => _inputNumber('7'), Colors.grey[800]!, Colors.white),
                          _buildButton('8', () => _inputNumber('8'), Colors.grey[800]!, Colors.white),
                          _buildButton('9', () => _inputNumber('9'), Colors.grey[800]!, Colors.white),
                          _buildButton('×', () => _inputOperation('×'), Colors.orange, Colors.white),
                        ],
                      ),
                    ),
                    
                    // Row 3: 4, 5, 6, -
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4', () => _inputNumber('4'), Colors.grey[800]!, Colors.white),
                          _buildButton('5', () => _inputNumber('5'), Colors.grey[800]!, Colors.white),
                          _buildButton('6', () => _inputNumber('6'), Colors.grey[800]!, Colors.white),
                          _buildButton('-', () => _inputOperation('-'), Colors.orange, Colors.white),
                        ],
                      ),
                    ),
                    
                    // Row 4: 1, 2, 3, +
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', () => _inputNumber('1'), Colors.grey[800]!, Colors.white),
                          _buildButton('2', () => _inputNumber('2'), Colors.grey[800]!, Colors.white),
                          _buildButton('3', () => _inputNumber('3'), Colors.grey[800]!, Colors.white),
                          _buildButton('+', () => _inputOperation('+'), Colors.orange, Colors.white),
                        ],
                      ),
                    ),
                    
                    // Row 5: 0, ., =
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('0', () => _inputNumber('0'), Colors.grey[800]!, Colors.white, flex: 2),
                          _buildButton('.', _inputDecimal, Colors.grey[800]!, Colors.white),
                          _buildButton('=', _performCalculation, Colors.orange, Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    VoidCallback onPressed,
    Color backgroundColor,
    Color textColor, {
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 0,
            padding: const EdgeInsets.all(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
