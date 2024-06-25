import 'package:flutter/material.dart';
import 'dart:math';

main() => runApp(
    const MaterialApp(
        home: Page()
    )
);
class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  int openBracesCount = 0;
  String expression = '';
  String output = 'still not good';
  Color opColor = Colors.white38;

  List<String> numbers = [
    '7', '8', '9',
    '4', '5', '6',
    '1', '2', '3',
    '0', ' . '
  ];
  List<dynamic> inToPost(String expression) {
    // print(expression);
    var precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '%': 3, '^': 4};
    var result = [];
    var stack = [];
    for (var i = 0; i < expression.length; i++) {
      var ch = expression[i];
      if (ch.runes.any((rune) => (rune >= 48 && rune <= 57) || rune == 46)) {
        // for multidigit number
        if (i > 0 && expression[i - 1].runes.any((rune) => (rune >= 48 && rune <= 57) || rune == 46)) {
          result[result.length - 1] += ch;
          continue;
        }
        result.add(ch);
      } else if (ch == '(') {
        stack.add(ch);
      } else if (ch == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          result.add(stack.removeLast());
        }
        try {
          stack.removeLast(); // Pop '('
        } catch (e) {
          throw Exception;
        }
      } else {
        while (stack.isNotEmpty &&
            (precedence[ch] ?? 0) <= (precedence[stack.last] ?? 0) &&
            stack.last != '(') {
          result.add(stack.removeLast());
        }
        stack.add(ch);
      }
    }
    while (stack.isNotEmpty) {
      if (stack.last == '(') {
        throw Exception;
        // return ['Invalid Expression'];
      }
      result.add(stack.removeLast());
    }
    // print(result);
    return result;
  }

  List<String> oper = ['-', '*', '^', '+', '/', '%'];
  String eval (String exper){
    List<dynamic> a = inToPost(exper);
    return evaluate(a);
  }

  String evaluate(List<dynamic> a) {
    var i = 0;
    while (a.isNotEmpty && i < a.length) {
      // print(a);
      if (oper.contains(a[i])) {
        var j = a.removeAt(i);
        i -= 2;
        var expr1 = double.parse(a.removeAt(i));
        var expr2 = double.parse(a.removeAt(i));
        if (j == '-') {
          a.insert(i, (expr1 - expr2).toString());
        }
        if (j == '*') {
          a.insert(i, (expr1 * expr2).toString());
        }
        if (j == '^') {
          a.insert(i, (pow(expr1, expr2)).toString());
        }
        if (j == '/') {
          if (expr2 == 0) throw IntegerDivisionByZeroException;
          a.insert(i, (expr1 ~/ expr2).toString());
        }
        if (j == '+') {
          a.insert(i, (expr1 + expr2).toString());
        }
        if (j == '%') {
          a.insert(i, (expr1 % expr2).toString());
        }
      }
      i++;
    }
    // print(int.parse(a[0]));
    return a[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 80,),
            SizedBox(
              // alignment: AlignmentGeometry<>,
              height: 100,
              // width: MediaQuery.of(context).size.width,
              // color: Colors.grey.shade900,
              child: SelectableText(expression,
                style: TextStyle(
                    fontSize: 80,
                    letterSpacing: 4,
                    color: Colors.grey.shade500
                ),
              ),
            ),
            // const SizedBox(height: 15,),
            SizedBox(
              height: 80,
              child: SelectableText(
                output,
                style: TextStyle(
                  color: opColor,
                  fontSize: 60,
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              // Don't ask. I didn't know how to use a list.
              // Lets just say I wanted something special for each button
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('*') || expression.endsWith('+')
                          || expression.endsWith('-') || expression.endsWith('/')
                          || expression.endsWith('(') || expression.endsWith('%')
                          || expression.endsWith('^') || expression.isEmpty){}
                      else {
                        expression += '^';
                      }
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                  child: const Text(
                    '  ^  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('+') || expression.isEmpty
                          || expression.endsWith('-') || expression.endsWith('/')
                          || expression.endsWith('(') || expression.endsWith('%')){}
                      else if (expression.endsWith('*')){
                        expression = expression.substring(0,expression.length - 1);
                        expression += '/';
                      }
                      else {
                        expression += '/';
                      }
                    });
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size.square(45)),
                      backgroundColor: MaterialStateProperty.all(Colors.red)
                  ),
                  child: const Text(
                    ' log ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              // Don't ask. I didn't know how to use a list.
              // Lets just say I wanted something special for each button
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression = '';
                      output = '';
                      openBracesCount = 0;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple)
                  ),
                  child: const Text(
                    ' AC ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      print(openBracesCount);
                      if (expression.endsWith('*') || expression.endsWith('+')
                          || expression.endsWith('-') || expression.endsWith('/')
                          || expression.endsWith('(') || expression.endsWith('%')
                          || expression.endsWith('^') || expression.isEmpty)
                      {
                        expression += '(';
                        openBracesCount += 1;
                      }
                      else if(openBracesCount > 0){
                        expression += ')';
                        openBracesCount -= 1;
                      }
                      try{output = eval(expression);}
                      catch(Exception){output = '';}
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                  child: const Text(
                    '  [ ]  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('*') || expression.endsWith('+')
                          || expression.endsWith('-') || expression.endsWith('/')
                          || expression.endsWith('(') || expression.endsWith('%')
                          || expression.endsWith('^') || expression.isEmpty){}
                      else {
                        expression += '%';
                      }
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                  child: const Text(
                    '  %  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('+') || expression.isEmpty
                        || expression.endsWith('-') || expression.endsWith('/')
                        || expression.endsWith('(') || expression.endsWith('%')
                        || expression.endsWith('^')
                      ){}
                      else if (expression.endsWith('*')){
                        expression = expression.substring(0,expression.length - 1);
                        expression += '/';
                      }
                      else {
                        expression += '/';
                      }
                    });
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size.square(45)),
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                  child: const Text(
                    '   /  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '7';
                      try {
                        try {
                          output = eval(expression);
                        }
                        catch (IntegerDivisionByZeroException) {
                          output = '';
                        }                      }
                      catch (error) {
                        output = '';
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  7  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '8';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  8  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '9';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  9  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('*') || expression.endsWith('+')
                          || expression.endsWith('-') || expression.isEmpty
                          || expression.endsWith('(') || expression.endsWith('%')
                          || expression.endsWith('^')
                      ){}
                      else if(expression.endsWith('/')){
                        expression = expression.substring(0,expression.length - 1);
                        expression += '*';
                      }
                      else {
                        expression += '*';
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                  ),
                  child: const Text(
                    '  x  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '4';
                      output = eval(expression);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  4  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '5';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  5  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '6';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  6  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('-')){}
                      else if(expression.endsWith('+')){
                        expression = expression.substring(0,expression.length - 1);
                        expression += '-';
                      }
                      else {
                        expression += '-';
                      }
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                      minimumSize: MaterialStateProperty.all(Size.square(80))
                  ),
                  child: const Text(
                    '  -  ',
                    style: TextStyle(
                      fontSize: 44,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '1';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  1  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '2';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  2  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '3';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  3  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      if (expression.endsWith('*') || expression.endsWith('+')
                          || expression.endsWith('/') || expression.isEmpty
                          || expression.endsWith('(') || expression.endsWith('%')
                          || expression.endsWith('-')){}
                      else {
                        expression += '+';
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                  ),
                  child: const Text(
                    '  +  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ,
              children: [
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '0';
                      try {
                        output = eval(expression);
                      }
                      catch (IntegerDivisionByZeroException) {
                        output = '';
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  0  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      expression += '.';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                  child: const Text(
                    '  .  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: (){
                      setState(() {
                        int l = expression.length;
                        if (expression.endsWith(')')) openBracesCount--;
                        expression = expression.substring(0,l-1);
                        try {
                          output = eval(expression);
                        }
                        catch (IntegerDivisionByZeroException) {
                          output = '';
                        }
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                        minimumSize: MaterialStateProperty.all(Size.square(75))
                    ),
                    child: const Icon(
                      Icons.backspace_outlined,
                      size: 40,
                      color: Colors.white,
                    )
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      try {
                        output = eval(expression);
                        expression = output;
                        output = '';
                      }
                      catch (IntegerDivisionByZeroException) {
                        // opColor = Colors.red;
                        output = 'Cannot Divide By Zero';
                      }
                      catch (error) {
                        // opColor = Colors.red;
                        output = 'Error';
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white54),
                  ),
                  child: const Text(
                    '  =  ',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
