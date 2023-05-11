import 'dart:io';

class Data{
  static File? avatarFile;
  static String? name;
  static List<List<String>> schedules = List.generate(112, (i) => List.filled(2, "", growable: false), growable: false);
}