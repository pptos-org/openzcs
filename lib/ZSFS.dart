import 'dart:io';

class ZSFS {
  String file(FileName, Directory) {
    return File(Directory + FileName).readAsStringSync();
  }
}
