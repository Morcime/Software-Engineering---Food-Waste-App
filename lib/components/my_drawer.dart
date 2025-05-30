import 'package:flutter/material.dart';
import 'package:foode_waste_app_1/components/my_drawer_tile.dart';
import 'package:foode_waste_app_1/pages/settings_page.dart' show SettingsPage;
import 'package:foode_waste_app_1/services/auth/auth_service.dart';
import 'package:foode_waste_app_1/services/auth/login_or_register.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<void> logout(BuildContext context) async {
    final _authService = AuthService();
    await _authService.signOut();

    // Navigasi ke halaman login dan hapus semua halaman sebelumnya
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),

          MyDrawerTile(
            text: "HOME",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          MyDrawerTile(
            text: "SETTINGS",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),

          const Spacer(),

          MyDrawerTile(
            text: "LOGOUT",
            icon: Icons.logout,
            onTap: () async {
              await logout(context);
            },
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
