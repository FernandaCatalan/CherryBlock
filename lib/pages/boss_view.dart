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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(
          sections[selectedIndex],
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: colors.primary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "CHERRY BLOCK",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
              ),
              Divider(color: colors.onPrimary.withValues(alpha:0.3)),
              Expanded(
                child: ListView.builder(
                  itemCount: sections.length + 1,
                  itemBuilder: (context, i) {
                    if (i < sections.length) {
                      final index = i;
                      final title = sections[index];
                      return ListTile(
                        leading: Icon(Icons.circle, color: colors.onPrimary, size: 12),
                        title: Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                        selected: selectedIndex == index,
                        selectedTileColor: colors.secondaryContainer,
                        onTap: () {
                          setState(() => selectedIndex = index);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          Divider(color: colors.onPrimary.withValues(alpha:0.3)),
                          ListTile(
                            leading: Icon(Icons.arrow_back, color: colors.onPrimary),
                            title: Text(
                              "Volver al Home",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colors.onPrimary,
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
      body: _buildBody(theme, colors),
    );
  }

  Widget _buildBody(ThemeData theme, ColorScheme colors) {
    if (sections[selectedIndex] == "Trabajadores") {
      return ListView.builder(
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return ListTile(
            leading: Icon(Icons.person, color: colors.primary),
            title: Text(worker.nombre, style: theme.textTheme.bodyLarge),
            subtitle: Text(worker.puesto, style: theme.textTheme.bodyMedium),
            trailing: Icon(Icons.arrow_forward_ios, color: colors.outline),
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
            leading: Icon(Icons.business, color: colors.primary),
            title: Text(contractor.nombre, style: theme.textTheme.bodyLarge),
            subtitle: Text(
              'Cantidad de personas: ${contractor.cantidadPersonas}',
              style: theme.textTheme.bodyMedium,
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: colors.outline),
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
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
      ),
    );
  }
}
