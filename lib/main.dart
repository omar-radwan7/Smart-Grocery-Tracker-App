import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/app.dart';
import 'package:smart_grocery_tracker/providers/auth_provider.dart';
import 'package:smart_grocery_tracker/providers/food_provider.dart';
import 'package:smart_grocery_tracker/screens/auth/login_screen.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(const SmartGroceryApp());
}

class SmartGroceryApp extends StatelessWidget {
  const SmartGroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Grocery Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isAuthenticated) return const AppShell();
    return const _SplashScreen();
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();
  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  bool _showLogin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !context.read<AuthProvider>().isAuthenticated) {
        setState(() => _showLogin = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogin) return const LoginScreen();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.heroStart, AppTheme.heroEnd],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.heroShadow,
              ),
              child: const Icon(Icons.eco, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Smart Grocery',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark)),
            const SizedBox(height: 6),
            const Text('Track. Manage. Save.',
                style: TextStyle(fontSize: 14, color: AppTheme.textLight)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
                color: AppTheme.heroStart, strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }
}
