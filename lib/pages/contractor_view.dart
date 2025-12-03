import 'package:flutter/material.dart';
import '/services/database_helper.dart'; 

class ContractorView extends StatefulWidget {
  const ContractorView({super.key});

  @override
  State<ContractorView> createState() => _ContractorViewState();
}

class _ContractorViewState extends State<ContractorView> {
  int selectedIndex = 0;

  final List<String> sections = [
    "Cosecheros",
    "Cantidad de cajas",
    "Exportar datos"
  ];

  late Future<List<Map<String, dynamic>>> _trabajadoresFuture;

  @override
  void initState() {
    super.initState();
    _trabajadoresFuture = DatabaseHelper.instance.getAllTrabajadores();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          sections[selectedIndex],
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: colorScheme.primary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "CHERRY BLOCK",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              Divider(color: colorScheme.onPrimary.withValues(alpha: 0.3)),
              Expanded(
                child: ListView.builder(
                  itemCount: sections.length + 1,
                  itemBuilder: (context, i) {
                    if (i < sections.length) {
                      final index = i;
                      final title = sections[index];
                      return ListTile(
                        leading: Icon(Icons.circle,
                            color: colorScheme.onPrimary, size: 12),
                        title: Text(
                          title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        selected: selectedIndex == index,
                        selectedTileColor:
                            colorScheme.secondary.withValues(alpha:0.3),
                        onTap: () {
                          setState(() => selectedIndex = index);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          Divider(color: colorScheme.onPrimary.withValues(alpha:0.3)),
                          ListTile(
                            leading: Icon(Icons.arrow_back,
                                color: colorScheme.onPrimary),
                            title: Text(
                              "Volver al Home",
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            onTap: () => Navigator.popUntil(
                                context, (route) => route.isFirst),
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
    switch (selectedIndex) {
      case 0:
        return _buildCosecheros();
      case 1:
        return const Center(child: Text("Cantidad de cajas (pendiente)"));
      case 2:
        return const Center(child: Text("Exportar datos (pendiente)"));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCosecheros() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _trabajadoresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No hay trabajadores registrados."),
          );
        }

        final trabajadores = snapshot.data!;

        return ListView.builder(
          itemCount: trabajadores.length,
          itemBuilder: (context, index) {
            final trabajador = trabajadores[index];
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(trabajador['nombre'] ?? 'Sin nombre'),
                subtitle: Text("Código: ${trabajador['codigo'] ?? ''}"),
                trailing: Text("Cajas: ${trabajador['cajas'] ?? 0}"),
              ),
            );
          },
        );
      },
    );
  }
}
