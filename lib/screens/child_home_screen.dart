import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart' as ap;
import '../../utils/app_theme.dart';
import '../../widgets/aegis_widgets.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ap.AuthProvider>().currentUser!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const AegisLogo(size: 32),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AegisMind',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                Text('Hey, ${user.fullName.split(' ').first}!',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.childColor)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => context.read<ap.AuthProvider>().signOut(),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.childColor,
                child: Icon(Icons.child_care_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Welcome card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.childColor.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.childColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.childColor,
                    child: Icon(Icons.child_care_rounded,
                        color: Colors.white, size: 34),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Hi, ${user.fullName.split(' ').first}! 🌟',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Stay safe online. AegisMind is protecting you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status cards
            Row(
              children: [
                _statusCard(
                    context, 'Protection', 'Active',
                    Icons.shield_rounded, AppColors.success),
                const SizedBox(width: 14),
                _statusCard(
                    context, 'Screen Time', '2h 30m',
                    Icons.timer_rounded, AppColors.warning),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _statusCard(
                    context, 'Safe Browsing', 'ON',
                    Icons.security_rounded, AppColors.info),
                const SizedBox(width: 14),
                _statusCard(
                    context, 'Alerts', '0 Today',
                    Icons.notifications_rounded, AppColors.childColor),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Info',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _infoRow('Email', user.email,
                      Icons.mail_outline_rounded),
                  const Divider(height: 24),
                  _infoRow('Account Type', 'Child Account',
                      Icons.child_care_rounded),
                  if (user.parentId != null) ...[
                    const Divider(height: 24),
                    _infoRow('Linked to Parent', 'Account Connected',
                        Icons.family_restroom_rounded),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),
            AegisGradientButton(
              text: 'Sign Out',
              onPressed: () =>
                  context.read<ap.AuthProvider>().signOut(),
              icon: Icons.logout_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
