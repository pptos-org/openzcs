import 'package:args/args.dart';

final VERSION = '0.0.1-dev';

void main(List<String> arguments) {
  var parser = ArgParser();

  // add version option and print 0.0.1

  parser.addFlag('version', abbr: 'v', negatable: false,
      callback: (bool value) {
    if (value) {
      print(VERSION);
    }
  });

  // add help option and print help

  parser.addFlag('help', abbr: 'h', negatable: false, callback: (bool value) {
    if (value) {
      print('''
      Usage: openzcs [options] [input file]

      Options:
      -h, --help    Print this usage information.
      -v, --version Print the current version.
      ''');
    }
  });

  // parse arguments

  parser.parse(arguments);

  // print results
}
