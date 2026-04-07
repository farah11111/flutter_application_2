import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? profile;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final p = await AuthService.fetchProfile();
      setState(() {
        profile = p;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> handleLogout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  String formatJoinDate(String? date) {
    if (date == null || date.isEmpty) return 'Unknown';
    try {
      final dt = DateTime.parse(date);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }

  Widget statCard(String title, int value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11131C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = profile?.stats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: handleLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : profile == null
                  ? const Center(child: Text('No profile found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1F2E),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.cyanAccent.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 36,
                                  child: Icon(Icons.person, size: 36),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  profile!.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  profile!.email,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Joined ${formatJoinDate(profile!.joinDate)}',
                                  style: const TextStyle(color: Colors.white60),
                                ),
                                const SizedBox(height: 10),
                                Chip(
                                  label: Text(profile!.role),
                                  backgroundColor: profile!.role == 'admin'
                                      ? Colors.purple.withOpacity(0.2)
                                      : Colors.cyan.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Defense Statistics',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.35,
                            children: [
                              statCard(
                                'Total Analyzed',
                                stats?.analyzedPrompts ?? 0,
                              ),
                              statCard(
                                'Blocked Threats',
                                stats?.blockedThreats ?? 0,
                              ),
                              statCard(
                                'Allowed Prompts',
                                stats?.allowedPrompts ?? 0,
                              ),
                              statCard(
                                'Hesitate Cases',
                                stats?.hesitateCases ?? 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }
}
