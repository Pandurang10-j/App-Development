import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'vip_subscription_screen.dart'; // <-- IMPORTANT IMPORT

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    final authService = AuthService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFF6A11CB), Colors.white],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Header
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: user?.photoURL != null
                      ? ClipOval(
                          child: Image.network(
                            user!.photoURL!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF6A11CB),
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? user?.email ?? 'Guest User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: userProvider.isVIP
                        ? const Color(0xFFFFD700)
                        : userProvider.isAdmin
                            ? Colors.red
                            : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userProvider.isAdmin
                        ? 'Admin'
                        : userProvider.isVIP
                            ? 'VIP Member'
                            : userProvider.isGuest
                                ? 'Guest'
                                : 'Standard User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Books Read', '0', Icons.menu_book),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('Bookmarks', '0', Icons.bookmark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('Streak', '0 days', Icons.local_fire_department),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Menu Items Card
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 🔥 NEW VIP UPGRADE BUTTON
                      if (!userProvider.isVIP && !userProvider.isGuest)
                        _buildMenuItem(
                          icon: Icons.star,
                          title: 'Upgrade to VIP',
                          subtitle: 'Get unlimited access',
                          color: const Color(0xFFFFD700),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VIPSubscriptionScreen(),
                              ),
                            );
                          },
                        ),

                      _buildMenuItem(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.info,
                        title: 'About',
                        onTap: () {},
                      ),

                      // Logout
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'Sign Out',
                        color: Colors.red,
                        onTap: () async {
                          await authService.signOut();
                          userProvider.clearUser();

                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------
  // UI HELPERS
  // -------------------------

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6A11CB), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A11CB),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color ?? const Color(0xFF6A11CB)),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
