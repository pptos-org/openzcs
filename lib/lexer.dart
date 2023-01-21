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

lexer(String filePath) sync* {
  String fileName = filePath.split('\\').last;
  String fileDir = filePath
          .split('\\')
          .sublist(0, filePath.split('\\').length - 1)
          .join('\\') +
      '\\';

  String string = new ZSFS().file(fileName, fileDir);
  int j = 0;
  List<String> characters = [' ', '#', '\n', '(', ')', '"', ":", ";", "="];

  for (int i = 0; i < string.length; i++) {
    String line = '';
    if (characters.contains(string[i])) {
      if (string[i] != ' ') {
        dynamic lexeme = string.substring(j, i + 1);
        dynamic lexemediff = string.substring(j, i);
        j = i + 1;
        if (lexemediff != '') {
          line = lexemediff.replaceAll(RegExp('\n'), '<newline>');
        }
        line = lexeme
            .replaceAll(RegExp(lexemediff), '')
            .replaceAll(RegExp('\n'), '<newline>');
      } else {
        String lexeme = string.substring(j, i);
        j = i + 1;
        line = lexeme.replaceAll(RegExp('\n'), '<newline>');
      }
    }

    print(line);

    if (line.length != 1) {
      if (line.contains(RegExp('[0-9]'))) {
        if (line.contains(RegExp('[a-zA-Z]'))) {
          yield {'type': 'STR', 'id': '', 'value': line};
        } else {
          yield {'type': 'INT', 'id': '', 'value': line};
        }
      } else {
        if (line == 'Print') {
          yield {'type': 'PRINTFUNC', 'value': line};
        }
        if (line == 'Let') {
          yield {'type': 'LET', 'value': line};
        }
        if (line == 'Set') {
          yield {'type': 'SET', 'value': line};
        }
        if (line == 'be') {
          yield {'type': 'BE', 'value': line};
        }
        if (line == 'as') {
          yield {'type': 'as', 'value': line};
        } else if (line == '<newline>') {
          yield {'type': 'NL', 'id': '', 'value': line};
        } else if (line == '') {
          yield {'type': 'WS', 'id': '', 'value': ' '};
        } else {
          yield {'type': 'STR', 'id': '', 'value': line};
        }
      }
    } else {
      if (line == '#') {
        yield {'type': 'hash', 'id': '', 'value': line};
      } else if (line == ' ') {
        yield {'type': 'WS', 'id': '', 'value': line};
      } else if (line == ':') {
        yield {'type': 'colon', 'id': '', 'value': line};
      } else if (line == ';') {
        yield {'type': 'semicolon', 'id': '', 'value': line};
      } else if (line == '(') {
        yield {'type': 'LPAREN', 'id': '', 'value': line};
      } else if (line == ')') {
        yield {'type': 'RPAREN', 'id': '', 'value': line};
      } else if (line == '"') {
        yield {'type': 'QUOTE', 'id': '', 'value': line};
      } else if (line == '+') {
        yield {'type': 'ADD', 'id': '', 'value': line};
      } else if (line == '-') {
        yield {'type': 'SUBTRACT', 'id': '', 'value': line};
      } else if (line == '*') {
        yield {'type': 'MULTIPLY', 'id': '', 'value': line};
      } else if (line == '/') {
        yield {'type': 'DIVIDE', 'id': '', 'value': line};
      } else if (line == '=') {
        yield {'type': 'EQUAL', 'id': '', 'value': line};
      } else if (line.contains(RegExp('[0-9]'))) {
        yield {'type': 'INT', 'id': '', 'value': line};
      } else {
        yield {'type': 'STR', 'id': '', 'value': line};
      }
    }
  }
}

void main() {
  String filePath = 'C:\\Users\\Quinten Van Damme\\dev\\openzcs\\src\\test.zcs';

  for (var token in lexer(filePath)) {
    print(token);
  }
}
