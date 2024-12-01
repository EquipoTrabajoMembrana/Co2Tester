// import 'package:co2tester/presentation/pages/error_page/error_page.dart';
import 'package:co2tester/presentation/pages/home_page/home_page.dart';
import 'package:co2tester/presentation/theme/theme.dart';
import 'package:co2tester/presentation/theme/util.dart';
import 'package:co2tester/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppResources.supabaseUrl,
    anonKey: AppResources.supabaseAnonKey,
  );
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   runApp(ErrorWidgetClass(details));
  // };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Sen');
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Co2 Tester',
      themeMode: ThemeMode.system,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: const HomePage(),
    );
  }
}
