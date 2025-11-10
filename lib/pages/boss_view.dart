import 'package:flutter/material.dart';
import 'worker.dart';
import 'contractor.dart';
import 'workers_details.dart';
import 'contractor_details.dart';

class BossView extends StatefulWidget {
  const BossView({super.key});

  @override
  State<BossView> createState() => _BossViewState();
}

class _BossViewState extends State<BossView> {
  int selectedIndex = 0;

  final List<String> sections = [
    "Trabajadores",
    "Contratistas",
    "Packing",
    "Detalles fundo"
  ];

  final List<Worker> workers = [
    Worker(nombre: "Juan Pérez", rut: "15.345.678-9", puesto: "Tractorista", horas: 40),
    Worker(nombre: "María López", rut: "13.456.789-0", puesto: "Jefe de Huerto", horas: 45),
    Worker(nombre: "Carlos Díaz", rut: "21.567.890-1", puesto: "Jefe Packing", horas: 50),
    Worker(nombre: "Ana Torres", rut: "18.678.901-2", puesto: "Cocinera", horas: 30),
  ];

  final List<Contractor> contractors = [
    Contractor(nombre: "Empresa A", rut: "11.111.111-1", cantidadPersonas: 5),
    Contractor(nombre: "Empresa B", rut: "22.222.222-2", cantidadPersonas: 3),
    Contractor(nombre: "Empresa C", rut: "33.333.333-3", cantidadPersonas: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB22222),
        title: Text(
          sections[selectedIndex],
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFB22222),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "CHERRY BLOCK",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView.builder(
                  itemCount: sections.length + 1,
                  itemBuilder: (context, i) {
                    if (i < sections.length) {
                      final index = i;
                      final title = sections[index];
                      return ListTile(
                        leading: const Icon(Icons.circle, color: Colors.white, size: 12),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                        selected: selectedIndex == index,
                        selectedTileColor: Colors.pinkAccent.shade100,
                        onTap: () {
                          setState(() => selectedIndex = index);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          const Divider(color: Colors.white24),
                          ListTile(
                            leading: const Icon(Icons.arrow_back, color: Colors.white),
                            title: const Text(
                              "Volver al Home",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                            ),
                            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (sections[selectedIndex] == "Trabajadores") {
      return ListView.builder(
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: Text(worker.nombre, style: const TextStyle(color: Colors.black, fontFamily: 'Inter')),
            subtitle: Text(worker.puesto, style: const TextStyle(color: Colors.black, fontFamily: 'Inter')),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkerDetailView(worker: worker)),
              );
            },
          );
        },
      );
    }

    if (sections[selectedIndex] == "Contratistas") {
      return ListView.builder(
        itemCount: contractors.length,
        itemBuilder: (context, index) {
          final contractor = contractors[index];
          return ListTile(
            leading: const Icon(Icons.business, color: Colors.black),
            title: Text(contractor.nombre, style: const TextStyle(color: Colors.black, fontFamily: 'Inter')),
            subtitle: Text('Cantidad de personas: ${contractor.cantidadPersonas}',
                style: const TextStyle(color: Colors.black, fontFamily: 'Inter')),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContractorDetailView(contractor: contractor)),
              );
            },
          );
        },
      );
    }

    return Center(
      child: Text(
        sections[selectedIndex],
        style: const TextStyle(
          fontSize: 28,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
