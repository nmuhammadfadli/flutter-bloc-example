import 'database_initializer_stub.dart'
    if (dart.library.io) 'database_initializer_io.dart'
    if (dart.libray.html) 'database_initializer_web.dart';

Future<void> initializeDatabaseFactory() => initializeDatabaseFactoryImpl();
