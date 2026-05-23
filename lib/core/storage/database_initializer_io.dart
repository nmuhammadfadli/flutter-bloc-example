import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> initializeDatabaseFactoryImpl() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}