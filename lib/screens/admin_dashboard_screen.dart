import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart' as ap;
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/aegis_widgets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Users'),
    _NavItem(icon: Icons.family_restroom_rounded, label: 'Families'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Analytics'),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ap.AuthProvider>().currentUser!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(user),
          // Main content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(user),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(UserModel user) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.inputBorder, width: 0.5)),
      ),
      child: Column(
        children: [
          // Brand
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const AegisLogo(size: 36),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AegisMind',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const Text('Admin Console',
                        style: TextStyle(
                            color: AppColors.adminColor, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          // Nav items
          ...List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final selected = _selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 20),
                      const SizedBox(width: 12),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Spacer(),
          // User info + logout
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.adminColor.withOpacity(0.2),
                  child: const Icon(Icons.admin_panel_settings_rounded,
                      color: AppColors.adminColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const Text('Administrator',
                          style: TextStyle(
                              color: AppColors.adminColor, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded,
                      color: AppColors.textMuted, size: 18),
                  onPressed: () =>
                      context.read<ap.AuthProvider>().signOut(),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(UserModel user) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
            bottom: BorderSide(color: AppColors.inputBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            _navItems[_selectedIndex].label,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          // Notification bell
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.cardBgLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none_rounded,
                    color: AppColors.textSecondary, size: 20),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text('Add User',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildUsersContent();
      default:
        return _buildComingSoon(_navItems[_selectedIndex].label);
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          FutureBuilder<Map<String, int>>(
            future: _authService.getUserStats(),
            builder: (context, snapshot) {
              final stats = snapshot.data ??
                  {'total': 0, 'admins': 0, 'parents': 0, 'children': 0};
              return Row(
                children: [
                  _statCard('Total Users', stats['total'].toString(),
                      Icons.people_alt_rounded, AppColors.primary),
                  const SizedBox(width: 16),
                  _statCard('Admins', stats['admins'].toString(),
                      Icons.admin_panel_settings_rounded, AppColors.adminColor),
                  const SizedBox(width: 16),
                  _statCard('Parents', stats['parents'].toString(),
                      Icons.family_restroom_rounded, AppColors.parentColor),
                  const SizedBox(width: 16),
                  _statCard('Children', stats['children'].toString(),
                      Icons.child_care_rounded, AppColors.childColor),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          Text('Recent Users',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 16)),
          const SizedBox(height: 14),

          FutureBuilder<List<UserModel>>(
            future: _authService.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary));
              }
              final users = snapshot.data ?? [];
              return _buildUsersTable(users.take(5).toList());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUsersContent() {
    return FutureBuilder<List<UserModel>>(
      future: _authService.getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final users = snapshot.data ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _buildUsersTable(users),
        );
      },
    );
  }

  Widget _statCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 14),
            Text(value,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 28, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTable(List<UserModel> users) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: AppColors.inputBorder, width: 0.5)),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('NAME',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8))),
                Expanded(
                    flex: 4,
                    child: Text('EMAIL',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8))),
                Expanded(
                    flex: 2,
                    child: Text('ROLE',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8))),
                Expanded(
                    flex: 2,
                    child: Text('STATUS',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8))),
              ],
            ),
          ),
          // Table rows
          if (users.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('No users found',
                  style: TextStyle(color: AppColors.textMuted)),
            )
          else
            ...users.map((user) => _userRow(user)),
        ],
      ),
    );
  }

  Widget _userRow(UserModel user) {
    final roleDisplay = user.role == UserRole.admin
        ? UserRoleDisplay.admin
        : user.role == UserRole.parent
            ? UserRoleDisplay.parent
            : UserRoleDisplay.child;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.inputBorder, width: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      roleDisplay.color.withOpacity(0.2),
                  child: Text(
                    user.fullName.isNotEmpty
                        ? user.fullName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                        color: roleDisplay.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    user.fullName,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              user.email,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(flex: 2, child: RoleBadge(role: roleDisplay)),
          Expanded(
            flex: 2,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (user.isActive
                        ? AppColors.success
                        : AppColors.textMuted)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (user.isActive
                          ? AppColors.success
                          : AppColors.textMuted)
                      .withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: user.isActive
                          ? AppColors.success
                          : AppColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: user.isActive
                          ? AppColors.success
                          : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoon(String name) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.construction_rounded,
                color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 20),
          Text('$name — Coming Soon',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('This section is under development',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
