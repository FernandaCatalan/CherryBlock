import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Accede al tema actual
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
              Divider(color: colorScheme.onPrimary.withOpacity(0.3)),
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
                        selectedTileColor: colorScheme.secondary.withOpacity(0.3),
                        onTap: () {
                          setState(() => selectedIndex = index);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          Divider(color: colorScheme.onPrimary.withOpacity(0.3)),
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
      body: Center(
        child: Text(
          sections[selectedIndex],
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
