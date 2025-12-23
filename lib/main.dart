import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/helpers/data_migration.dart';
import 'firebase_options.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/services/keyboard_service.dart';
import 'core/helpers/initial_data_setup.dart';

import 'core/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DataMigration.migrateExistingData();
  await DataMigration.addMissingFieldsToProjects();

  Get.put(ThemeService());
  Get.put(KeyboardService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Syed Mahiuddin Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
    );
  }
}