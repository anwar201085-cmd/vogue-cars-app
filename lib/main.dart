import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/screens/home_screen_redesigned.dart';
import 'package:vogue_cars/screens/splash_screen.dart';
import 'package:vogue_cars/providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Note: Firebase initialization requires google-services.json / GoogleService-Info.plist
  // For now, we'll wrap it in a try-catch to allow the UI to be built.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase not initialized: $e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const VogueCarsApp(),
    ),
  );
}

class VogueCarsApp extends StatelessWidget {
  const VogueCarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    
    return MaterialApp(
      title: 'Vogue Cars',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: appProvider.locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        // Add localization delegates here
      ],
      home: const SplashScreen(),
    );
  }
}
