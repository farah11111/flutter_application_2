import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart' as ap;
import '../models/user_model.dart';
import 'login_screen.dart';
import 'admin_dashboard_screen.dart';
import 'parent_home_screen.dart';
import 'child_home_screen.dart';
import '../../utils/app_theme.dart';
import '../../widgets/aegis_widgets.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ap.AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.status) {
          case ap.AuthStatus.initial:
          case ap.AuthStatus.loading:
            return const _SplashScreen();

          case ap.AuthStatus.authenticated:
            final user = authProvider.currentUser!;
            switch (user.role) {
              case UserRole.admin:
                return const AdminDashboardScreen();
              case UserRole.parent:
                return const ParentHomeScreen();
              case UserRole.child:
                return const HomeScreen();
            }

          case ap.AuthStatus.unauthenticated:
          case ap.AuthStatus.error:
            return const LoginScreen();
        }
      },
    );
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AegisLogo(size: 88),
                  const SizedBox(height: 24),
                  Text(
                    'AegisMind',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'When Defense Meets Reasoning',
                    style: TextStyle(
                      color: AppColors.cyanLight,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

