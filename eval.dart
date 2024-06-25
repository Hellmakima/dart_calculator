import 'dart:math';
List<dynamic> inToPost(String expression) {
  var precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '%': 3, '^': 4};
  var result = [];
  var stack = [];
  for (var i = 0; i < expression.length; i++) {
    var ch = expression[i];
    if (ch.runes.any((rune) => rune >= 48 && rune <= 57)) {
      // for multidigit number
      if (i > 0 && expression[i - 1].runes.any((rune) => rune >= 48 && rune <= 57)) {
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
        return ['Invalid Expression'];
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
      return ['Invalid Expression'];
    }
    result.add(stack.removeLast());
  }
  return result;
}

List<String> oper = ['-', '*', '^', '+', '/', '%'];

String evaluate(List<dynamic> a) {
  var i = 0;
  while (a.isNotEmpty && i < a.length) {
    // print(a);
    if (oper.contains(a[i])) {
      var j = a.removeAt(i);
      i -= 2;
      var expr1 = int.parse(a.removeAt(i));
      var expr2 = int.parse(a.removeAt(i));
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
        if (expr2 == 0) return "Cannot divide by Zero";
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
  print(int.parse(a[0]));
  return a[0];
}

void main() {
  var infix = "(4/0)*((2^2)-1)^(2-(1*1))-20%6";
  try {
    var post = inToPost(infix);
    // print(post);
    print(evaluate(post));
  } catch (e) {
    print('Invalid Expression');
  }
}