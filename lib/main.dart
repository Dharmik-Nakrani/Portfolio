import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portfolio/app/modules/home/bindings/home_binding.dart';
import 'package:portfolio/app/modules/home/views/home_view.dart';
import 'package:portfolio/firebase_options.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dharmik Nakrani - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeView(),
      initialBinding: HomeBinding(),
    );
  }
}
