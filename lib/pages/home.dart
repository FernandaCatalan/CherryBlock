import 'package:cherry_block/pages/preferences_view.dart';
import 'package:flutter/material.dart';
import 'boss_view.dart';
import 'cuadrilla_view.dart';
import 'packing_view.dart';
import 'contractor_view.dart';
import 'planillero_view.dart';
import 'welcome_view.dart';
import 'acerca_view.dart';
import 'qr_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
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
            /*_roleButton(
              context,
              'Planillero',
              Icons.edit,
              const WelcomeView(
                roleName: 'Planillero',
                nextPage: PlanilleroView(),
              ),
            ),*/
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
            _roleButton(
              context,
              'Test QR',
              Icons.info,
              const QRViewPage(),
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
