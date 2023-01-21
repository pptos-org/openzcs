import 'ZSFS.dart';

class User {
  final name;

  User(this.name);
}

class BinaryNode<T> {
  BinaryNode(this.value);
  T value;
  BinaryNode<T>? leftChild;
  BinaryNode<T>? rightChild;
  @override
  String toString() {
    return _diagram(this);
  }

  // add a new node to the left of this node
  void addLeft(T value) {
    final node = BinaryNode(value);
    node.leftChild = leftChild;
    leftChild = node;
  }

  // add a new node to the right of this node
  void addRight(T value) {
    final node = BinaryNode(value);
    node.rightChild = rightChild;
    rightChild = node;
  }

  String _diagram(
    BinaryNode<T>? node, [
    String top = '',
    String root = '',
    String bottom = '',
  ]) {
    if (node == null) {
      return '$root null\n';
    }
    if (node.leftChild == null && node.rightChild == null) {
      return '$root ${node.value}\n';
    }
    final a = _diagram(
      node.rightChild,
      '$top ',
      '$top┌──',
      '$top│ ',
    );
    final b = '$root${node.value}\n';
    final c = _diagram(
      node.leftChild,
      '$bottom│ ',
      '$bottom└──',
      '$bottom ',
    );
    return '$a$b$c';
  }
}

dynamic v2() sync* {
  String string = new ZSFS().file(
      'meow.zcs', 'C:\\Users\\Quinten Van Damme\\Downloads\\openzcs\\src\\');
  int j = 0;
  List<String> characters = [' ', '#', '\n', '(', ')', '"'];

  for (int i = 0; i < string.length; i++) {
    if (characters.contains(string[i])) {
      if (string[i] != ' ') {
        dynamic lexeme = string.substring(j, i + 1);
        dynamic lexemediff = string.substring(j, i);
        j = i + 1;
        if (lexemediff != '') {
          yield lexemediff.replaceAll(RegExp('\n'), '<newline>');
        }
        yield lexeme
            .replaceAll(RegExp(lexemediff), '')
            .replaceAll(RegExp('\n'), '<newline>');
      } else {
        String lexeme = string.substring(j, i);
        j = i + 1;
        yield lexeme.replaceAll(RegExp('\n'), '<newline>');
      }
    }
  }
}

Map<String, String> lexer(input) {
  // if input contains numbers or letters return string
  if (input.length != 1) {
    if (input.contains(RegExp('[0-9]'))) {
      if (input.contains(RegExp('[a-zA-Z]'))) {
        return {'type': 'STR', 'id': '', 'value': input};
      } else {
        return {'type': 'INT', 'id': '', 'value': input};
      }
    } else {
      if (input == 'Print') {
        return {'type': 'PRINTFUNC', 'value': input};
      }
      if (input == 'Let') {
        return {'type': 'LET', 'value': input};
      }
      if (input == 'Set') {
        return {'type': 'SET', 'value': input};
      }
      if (input == 'be') {
        return {'type': 'BE', 'value': input};
      }
      if (input == 'as') {
        return {'type': 'as', 'value': input};
      } else if (input == '<newline>') {
        return {'type': 'NL', 'id': '', 'value': input};
      } else if (input == '') {
        return {'type': 'WS', 'id': '', 'value': ' '};
      } else {
        return {'type': 'STR', 'id': '', 'value': input};
      }
    }
  } else {
    if (input == '#') {
      return {'type': 'hash', 'id': '', 'value': input};
    } else if (input == ' ') {
      return {'type': 'WS', 'id': '', 'value': input};
    } else if (input == '(') {
      return {'type': 'LPAREN', 'id': '', 'value': input};
    } else if (input == ')') {
      return {'type': 'RPAREN', 'id': '', 'value': input};
    } else if (input == '"') {
      return {'type': 'QUOTE', 'id': '', 'value': input};
    } else if (input == '+') {
      return {'type': 'ADD', 'id': '', 'value': input};
    } else if (input == '-') {
      return {'type': 'SUBTRACT', 'id': '', 'value': input};
    } else if (input == '*') {
      return {'type': 'MULTIPLY', 'id': '', 'value': input};
    } else if (input == '/') {
      return {'type': 'DIVIDE', 'id': '', 'value': input};
    } else if (input == '=') {
      return {'type': 'EQUAL', 'id': '', 'value': input};
    } else if (input.contains(RegExp('[0-9]'))) {
      return {'type': 'INT', 'id': '', 'value': input};
    } else {
      return {'type': 'STR', 'id': '', 'value': input};
    }
  }
}

_check_program(List<dynamic> tokens) {
  _check_header(List<dynamic> tokens) {
    if (tokens[0].startsWith(RegExp('[^<]')) ||
        tokens[1] != ':' ||
        tokens[2] != 'Application' ||
        tokens[3] != 'ZCS>') throw 'Invalid header';
  }

  _check_footer(List<dynamic> tokens) {
    if (tokens[tokens.length - 2].startsWith(RegExp('[^</]')) ||
        !tokens[tokens.length - 2].endsWith('>')) throw 'Invalid footer';
  }

  _check_name(List<dynamic> tokens) {
    var name_header = tokens[0].substring(1);
    var name_footer = tokens[tokens.length - 2]
        .substring(2, tokens[tokens.length - 2].length - 1);
    if (name_header != name_footer ||
        name_header.length == 0 ||
        name_header == ' ') throw 'Invalid name';
  }

  _check_header(tokens);
  _check_footer(tokens);
  _check_name(tokens);
}

make_calc_tree(input, i_input) {
  // if input.leftChild.value passes int.parse, then it is an int and we can add it to the right child
  // // check if i_input is the same as inputlength
  if (i_input != input.length - 1) {
    var node = BinaryNode(input[i_input]);
    node.addLeft(input[i_input + 1]);
    if (i_input + 2 == input.length - 1) {
      node.addRight(input[i_input + 2]);
    } else {
      node.rightChild = make_calc_tree(input, i_input + 2);
    }
    return node;
  }
}

calc(input) {
  switch (input.value) {
    case 'ADD':
      return calc(input.leftChild) + calc(input.rightChild);
    case 'SUBTRACT':
      return calc(input.leftChild) - calc(input.rightChild);
    case 'MULTIPLY':
      return calc(input.leftChild) * calc(input.rightChild);
    case 'DIVIDE':
      return calc(input.leftChild) / calc(input.rightChild);
    default:
      return int.parse(input.value);
  }
}

BinaryNode<dynamic> tree() {
  dynamic converted_result = v2();
  List string = converted_result.toList();
  //_check_program(string);
  string.removeRange(0, 4); // remove first 4 elements of the list
  string.removeAt(
      string.length - 2); // remove last the second last element of the list

  // remove all the newlines from the list with type WS
  for (var i = 0; i < string.length - 1; i++) {
    if (lexer(string[i])['type'] == 'WS') {
      string.removeAt(i);
      i--;
    }
  }

  list1(i, list) {
    List ops = ['+', '-', '*', '/'];
    var calcString;

    if (lexer(string[i])['type'] == 'STR') {
      if (lexer(string[i + 1])['type'] == 'EQUAL') {
        if (lexer(string[i + 2])['type'] != 'QUOTE') {
          if (ops.contains(lexer(string[i + 3])['value'])) {
            getCalcString() {
              _getPointerValue(i) {
                List pointers = [];
                for (var j = 0; j < list.length; j++) {
                  if (list[j] != null) {
                    if (list[j]['id'] == lexer(string[i])['value']) {
                      pointers.add(list[j]['value']);
                    }
                  }
                }
                return pointers.toList();
              }

              for (var i = 0; i < string.length; i++) {
                if (ops.contains(lexer(string[i + 2])['value']) ||
                    ops.contains(lexer(string[i + 3])['value'])) {
                  if (calcString == null) {
                    if (!_getPointerValue(i + 2).isEmpty) {
                      calcString = '${_getPointerValue(i + 2).last}';
                    } else {
                      calcString = '${lexer(string[i + 2])['value']}';
                    }
                  } else {
                    if (!_getPointerValue(i + 2).isEmpty) {
                      calcString =
                          '$calcString ${_getPointerValue(i + 2).last}';
                    } else {
                      calcString =
                          '$calcString ${lexer(string[i + 2])['value']}';
                    }
                  }
                } else if (ops.contains(lexer(string[i + 1])['value']) &&
                    !ops.contains(lexer(string[i + 3])['value'])) {
                  return '$calcString ${lexer(string[i + 2])['value']}';
                }
              }
              return calcString;
            }

            return {
              'type': 'VAR',
              'id': '${lexer(string[i])['value']}',
              'value': '${getCalcString()}'
            };
          }
          _getPointerValue() {
            List pointers = [];
            for (var j = 0; j < list.length; j++) {
              if (list[j] != null) {
                if (list[j]['id'] == lexer(string[i + 2])['value']) {
                  pointers.add(list[j]);
                }
              }
            }
            return pointers.toList();
          }

          if (_getPointerValue().isEmpty) {
            return {
              'type': '${lexer(string[i + 2])['type']}',
              'id': '${lexer(string[i])['value']}',
              'value': '${lexer(string[i + 2])['value']}'
            };
          } else {
            var pointer = _getPointerValue().last;
            return {
              'type': '${pointer['type']}',
              'id': '${lexer(string[i])['value']}',
              'value': '${pointer['value']}'
            };
          }
        }
      } else if (lexer(string[i + 1])['type'] == 'RPAREN' &&
          lexer(string[i - 1])['type'] == 'LPAREN') {
        _getPointerValue() {
          List pointers = [];
          for (var j = 0; j < list.length; j++) {
            if (list[j] != null) {
              if (list[j]['id'] == lexer(string[i])['value']) {
                pointers.add(list[j]);
              }
            }
          }
          return pointers.toList();
        }

        if (_getPointerValue().isEmpty) {
          return {
            'type': '${lexer(string[i])['type']}',
            'id': '${lexer(string[i])['id']}',
            'value': '${lexer(string[i])['value']}'
          };
        } else {
          var pointer = _getPointerValue().last;
          return {
            'type': '${pointer['type']}',
            'id': '${lexer(string[i])['value']}',
            'value': '${pointer['value']}'
          };
        }
      }
    } else {
      return lexer(string[i]);
    }
  }

  list2() {
    List list = [];
    for (var i = 0; i < string.length; i++) {
      list.add(list1(i, list));
    }
    return list;
  }

  ///////////
  // debug //
  ///////////

  //for (var i = 0; i < string.length; i++) {
  //  print(lexer(string[i]));
  //}

  string = list2();

  make_tree(input, i_input) {
    var node = BinaryNode(input[i_input]);
    _index_of_newlines() sync* {
      for (var i = 0; i < input.length; i++) {
        if (input[i] != null) {
          if (input[i]['type'] == 'NL') {
            yield i;
          }
        }
      }
    }

    if (i_input != input.length - 1) {
      if (input[i_input]['type'] != 'NL' || i_input == 0) {
        sub_tree(string, i_input, int cyclenum) {
          var index_of_newlines = _index_of_newlines().toList();
          var node = BinaryNode(input[index_of_newlines[cyclenum]]);
          node.leftChild = make_tree(string, index_of_newlines[cyclenum] + 1);
          if (index_of_newlines.length - 1 != cyclenum) {
            node.rightChild = sub_tree(string, i_input, cyclenum + 1);
          }
          return node;
        }

        if (input[i_input] != null) {
          if (i_input == 0 || input[i_input]['type'] == 'NL') {
            node.rightChild = sub_tree(string, i_input, 1);
          }
        }

        if (input[i_input + 1] != null) {
          if (input[i_input + 1]['type'] != 'NL') {
            node.leftChild = make_tree(input, i_input + 1);
          }
          if (input[i_input + 1]['type'] == 'EQUAL') {
            node.leftChild = null;
          }
        }
      }
    }
    return node;
  }

  return make_tree(string, 0);
}

void main() {
  // print the value of tree()
  //print(tree().value);
}
