import 'package:flutter/material.dart';
import 'boss_view.dart';
import 'cuadrilla_view.dart';
import 'packing_view.dart';
import 'contractor_view.dart';
import 'planillero_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 233, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 34, 34),
        title: const Text('Cherry Block'),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
            _roleButton(context, 'Dueño', Icons.account_balance, Color.fromARGB(255, 178, 34, 34), const BossView()),
            _roleButton(context, 'Jefe de Cuadrilla', Icons.group, Color.fromARGB(255, 178, 34, 34), const CuadrillaView()),
            _roleButton(context, 'Jefe de Packing', Icons.local_shipping, Color.fromARGB(255, 178, 34, 34), const PackingView()),
            _roleButton(context, 'Contratista', Icons.handshake, Color.fromARGB(255, 178, 34, 34), const ContractorView()),
            _roleButton(context, 'Planillero', Icons.edit, Color.fromARGB(255, 178, 34, 34), const PlanilleroView()),
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
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}