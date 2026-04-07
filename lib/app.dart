import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';

class AegisMindApp extends StatefulWidget {
  const AegisMindApp({super.key});

  @override
  State<AegisMindApp> createState() => _AegisMindAppState();
}

class _AegisMindAppState extends State<AegisMindApp> {
  @override
  Widget build(BuildContext context) {
    final loggedIn = AuthService.currentSession != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AegisMind',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090E1A),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E1422),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1B2233),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.cyanAccent.withOpacity(0.15),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF111827),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.cyanAccent.withOpacity(0.25),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.cyanAccent,
              width: 1.4,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0EA5E9),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: MainShell(
        loggedIn: loggedIn,
        onAuthChanged: () {
          setState(() {});
        },
      ),
    );
  }
}

class MainShell extends StatelessWidget {
  final bool loggedIn;
  final VoidCallback onAuthChanged;

  const MainShell({
    super.key,
    required this.loggedIn,
    required this.onAuthChanged,
  });

  Future<void> openLogin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );

    if (result == true) {
      onAuthChanged();
    }
  }

  Future<void> openProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );

    if (result == true) {
      onAuthChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shield_outlined, color: Colors.cyanAccent),
            SizedBox(width: 10),
            Text('AegisMind'),
          ],
        ),
        actions: [
          if (loggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () => openProfile(context),
                icon: const Icon(Icons.person),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () => openLogin(context),
                child: const Text('Login'),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          const AppBackground(),
          Column(
            children: [
              const Expanded(child: HomeScreen()),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1422).withOpacity(0.92),
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.08)),
                  ),
                ),
                child: const Column(
                  children: [
                    Text(
                      'AegisMind – Graduation Project',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'AI Safety & Prompt Defense System',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF050816),
            Color(0xFF0A1020),
            Color(0xFF050816),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 260,
            right: 40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent.withOpacity(0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
