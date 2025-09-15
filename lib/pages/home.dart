import 'package:flutter/material.dart';
import 'boss_view.dart';
import 'cuadrilla_view.dart';
import 'packing_view.dart';
import 'contractor_view.dart';
import 'planillero_view.dart';
import 'welcome_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E9DA),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C4033),
        title: const Text('Cherry Block'),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFAFAFA),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
              Color(0xFFB22222), 
              const WelcomeView(
                roleName: 'Dueño', 
                nextPage: BossView(),
              )),
            _roleButton(
              context, 
              'Jefe de Cuadrilla', 
              Icons.group, 
              Color(0xFFB22222), 
              const WelcomeView(
                roleName: 'Jefe de Cuadrilla', 
                nextPage: CuadrillaView(),
              )),
            _roleButton(
              context, 
              'Jefe de Packing', 
              Icons.local_shipping, 
              Color(0xFFB22222), 
              const WelcomeView(
                roleName: 'Jefe de Packing', 
                nextPage: PackingView(),
              )),
            _roleButton(
              context, 
              'Contratista', 
              Icons.handshake, 
              Color(0xFFB22222), 
              const WelcomeView(
                roleName: 'Contratista', 
                nextPage: ContractorView(),
              )),
            _roleButton(
              context, 
              'Planillero', 
              Icons.edit, 
              Color(0xFFB22222), 
              const WelcomeView(
                roleName: 'Planillero', 
                nextPage: PlanilleroView(),
              )),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(BuildContext context, String title, IconData icon, Color color, Widget view) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => view),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Color(0xFFFAFAFA)),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFAFAFA),
            ),
          ),
        ],
      ),
    );
  }
}