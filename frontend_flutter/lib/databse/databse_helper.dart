import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatsapp_clone/const_files/db_names.dart';
import 'package:whatsapp_clone/databse/db_models/db_message_model.dart';
import 'package:whatsapp_clone/databse/db_models/db_pending_message_model.dart';
import 'package:whatsapp_clone/databse/db_models/db_user_model.dart';

class DatabaseHelper {
  Future<void> initDB() async {
    await Hive.initFlutter();

    //type adapter registration
    Hive.registerAdapter(DbUserModelAdapter());
    Hive.registerAdapter(DbMessageModelAdapter());
    Hive.registerAdapter(DbPendingMessageModelAdapter());

    // open hive box
    await Hive.openBox<DbMessageModel>(DbNames.message);
    await Hive.openBox<DbPendingMessageModel>(DbNames.pendingMessage);
  }
}
