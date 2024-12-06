import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/providers/app_theme_provider.dart';

import 'app/data/hive_data_storage.dart';
import 'app/home/home_view.dart';
import 'app/model/task.dart';

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  try {
    await Hive.initFlutter();
    Hive.registerAdapter<Task>(TaskAdapter());
    var box = await Hive.openBox<Task>(HiveDataStorage.boxName);

    for (var task in box.values) {
      if (task.date.isBefore(DateTime.now())) {
        task.delete();
      }
    }
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      navigatorObservers: [routeObserver],
      themeMode: themeProvider.themeState == ThemeState.light
          ? ThemeMode.light
          : ThemeMode.dark,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomeView(),
    );
  }
}
