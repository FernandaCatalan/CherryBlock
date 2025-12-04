import 'package:cherry_block/pages/preferences_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boss_view.dart';
import 'cuadrilla_view.dart';
import 'packing_view.dart';
import 'contractor_view.dart';
import 'planillero_view.dart';
import 'welcome_view.dart';
import 'acerca_view.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', false);
    await prefs.setBool('is_logged_in', false);
    
    await FirebaseAuth.instance.signOut();
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          'CHERRY BLOCK',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (user != null)
            PopupMenuButton<String>(
              icon: Icon(Icons.account_circle, color: colorScheme.onPrimary),
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutDialog();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Usuario',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.email ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Cerrar sesión'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          children: [
            _roleButton(
              context,
              'Dueño',
              Icons.account_balance,
              WelcomeView(roleName: 'Dueño', nextPage: const BossView()),
            ),
            _roleButton(
              context,
              'Jefe de Cuadrilla',
              Icons.group,
              const WelcomeView(
                roleName: 'Jefe de Cuadrilla',
                nextPage: CuadrillaView(),
              ),
            ),
            _roleButton(
              context,
              'Jefe de Packing',
              Icons.local_shipping,
              const WelcomeView(
                roleName: 'Jefe de Packing',
                nextPage: PackingView(),
              ),
            ),
            _roleButton(
              context,
              'Contratista',
              Icons.handshake,
              const WelcomeView(
                roleName: 'Contratista',
                nextPage: ContractorView(),
              ),
            ),
            _roleButton(
              context,
              'Planillero',
              Icons.edit,
              const WelcomeView(
                roleName: 'Planillero',
                nextPage: PlanilleroView(),
              ),
            ),
            _roleButton(
              context,
              'Preferencias',
              Icons.settings,
              const PreferencesView(),
            ),
            _roleButton(
              context,
              'Acerca de',
              Icons.info,
              const AcercaView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(
      BuildContext context, String title, IconData icon, Widget view) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => view),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: colorScheme.onPrimary),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}