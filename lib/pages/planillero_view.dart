import 'package:flutter/material.dart';
import '/services/nfc_service.dart';
import '/services/database_helper.dart';

class PlanilleroView extends StatefulWidget {
  const PlanilleroView({super.key});

  @override
  State<PlanilleroView> createState() => _PlanilleroViewState();
}

class _PlanilleroViewState extends State<PlanilleroView> {
  int selectedIndex = 0;
  final List<String> sections = ["Registrar trabajadores", "Alertas"];

  final _nfcService = NFCService();
  final _db = DatabaseHelper.instance;
  bool _isLoading = false;
  String? _detectedTag;
  Map<String, dynamic>? _existingWorker;

  final _formKey = GlobalKey<FormState>();
  String _nombre = "";
  String _codigo = "";
  String _cajas = "";

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
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
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
                      return ListTile(
                        leading: Icon(Icons.circle,
                            color: colorScheme.onPrimary, size: 12),
                        title: Text(
                          sections[index],
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onPrimary),
                        ),
                        selected: selectedIndex == index,
                        selectedTileColor:
                            colorScheme.secondary.withOpacity(0.3),
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
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: colorScheme.onPrimary),
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
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Esperando lectura NFC..."),
                ],
              ),
            )
          : selectedIndex == 0
              ? _buildRegistrarTrabajadores(context, colorScheme)
              : _buildAlertas(context, colorScheme),
    );
  }

  Widget _buildRegistrarTrabajadores(
      BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _leerNfc,
              icon: const Icon(Icons.nfc),
              label: const Text("Registrar con NFC"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
            const SizedBox(height: 30),
            if (_detectedTag != null) _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    final esExistente = _existingWorker != null;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                esExistente
                    ? "Etiqueta registrada — ingresar cantidad de cajas"
                    : "Etiqueta nueva — registrar trabajador",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (!esExistente) ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: "Nombre"),
                  onSaved: (v) => _nombre = v ?? "",
                  validator: (v) =>
                      v == null || v.isEmpty ? "Ingrese un nombre" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Código"),
                  onSaved: (v) => _codigo = v ?? "",
                  validator: (v) =>
                      v == null || v.isEmpty ? "Ingrese un código" : null,
                ),
              ],
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Cantidad de cajas"),
                keyboardType: TextInputType.number,
                onSaved: (v) => _cajas = v ?? "",
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese una cantidad" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarDatos,
                child: Text(esExistente ? "Actualizar cajas" : "Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertas(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Text(
        "No hay alertas disponibles.",
        style: TextStyle(color: colorScheme.primary, fontSize: 18),
      ),
    );
  }

  /// 🔹 Leer NFC y verificar si ya existe en la base de datos
  Future<void> _leerNfc() async {
    setState(() {
      _isLoading = true;
      _detectedTag = null;
      _existingWorker = null;
    });

    try {
      final tagData = await _nfcService.readNfcTag();

      if (tagData != null && !(tagData.contains("no disponible"))) {
        // 🔍 Buscar si ya existe
        final existing = await _db.buscarTrabajadorPorEtiqueta(tagData);

        setState(() {
          _detectedTag = tagData;
          _existingWorker = existing; // null si no existe
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se detectó ninguna etiqueta NFC")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Guardar o actualizar datos
  Future<void> _guardarDatos() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    final esExistente = _existingWorker != null;

    if (esExistente) {
      // 🔄 Solo actualizar cantidad de cajas
      final updated = {
        "id": _existingWorker!["id"],
        "nombre": _existingWorker!["nombre"],
        "codigo": _existingWorker!["codigo"],
        "cajas": _existingWorker!["cajas"] + int.parse(_cajas),
        "etiqueta_nfc": _existingWorker!["etiqueta_nfc"],
        "fecha_registro": DateTime.now().toIso8601String(),
      };
      await _db.updateTrabajador(updated);
    } else {
      // 🆕 Nuevo registro
      final nuevo = {
        "nombre": _nombre,
        "codigo": _codigo,
        "cajas": int.parse(_cajas),
        "etiqueta_nfc": _detectedTag!,
        "fecha_registro": DateTime.now().toIso8601String(),
      };
      await _db.insertTrabajador(nuevo);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(esExistente
          ? "Cantidad de cajas actualizada correctamente"
          : "Trabajador registrado correctamente"),
    ));

    setState(() {
      _detectedTag = null;
      _existingWorker = null;
      _formKey.currentState?.reset();
    });
  }
}
