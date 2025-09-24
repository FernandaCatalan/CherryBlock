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
      body: Center(
        child: Text(
          sections[selectedIndex],
          style: const TextStyle(
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFFB22222),
          ),
        ),
      ),
    );
  }
}
