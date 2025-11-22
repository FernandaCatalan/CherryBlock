import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cherry_block/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({super.key});

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  final db = DatabaseHelper.instance;

  List<Map<String, dynamic>> _workers = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = false;

  String? _scannedCode;
  Map<String, dynamic>? _currentWorker;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorkers();
  }

  Future<void> _loadWorkers() async {
    setState(() => _loading = true);
    try {
      final list = await db.getAllTrabajadores();
      setState(() {
        _workers = list;
        _filtered = List.from(_workers);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error cargando trabajadores: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _startScanner() async {
    final code = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const _ScannerScreen()),
    );

    if (code == null) return;

    setState(() {
      _scannedCode = code;
      _currentWorker = null;
    });

    try {
      final existing = await db.getTrabajadorByCodigo(code);
      setState(() {
        _currentWorker = existing;
      });
    } catch (e) {
      debugPrint('Error buscando trabajador por código: $e');
    }

    await _loadWorkers();
  }

  Future<List<String>> _getIdentificadoresOf(int trabajadorId) async {
    try {
      final database = await db.database;
      final rows = await database.query(
        'identificadores',
        columns: ['valor'],
        where: 'trabajador_id = ?',
        whereArgs: [trabajadorId],
      );
      return rows.map((r) => (r['valor'] ?? '').toString()).where((s) => s.isNotEmpty).toList();
    } catch (e) {
      debugPrint('Error obteniendo identificadores: $e');
      return [];
    }
  }

  Future<void> _saveNewWorker(String nombre, String codigo, String identificadoresCsv, int cajas) async {
    if (codigo.isEmpty || nombre.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nombre y código requeridos')));
      return;
    }

    final nuevo = {
      'nombre': nombre.trim(),
      'codigo': codigo.trim(),
      'cajas': cajas,
    };

    try {
      final id = await db.insertTrabajador(nuevo);

      final ids = identificadoresCsv.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      for (final idf in ids) {
        try {
          await db.agregarIdentificador(id, idf);
        } catch (e) {
          debugPrint('No se pudo agregar identificador $idf: $e');
        }
      }

      if (cajas > 0) {
        try {
          await db.sumarCajas(id, cajas);
        } catch (_) {

          try {
            final database = await db.database;
            await database.insert('registros', {
              'trabajador_id': id,
              'cantidad': cajas,
              'hora': DateTime.now().toIso8601String(),
            });
            await database.rawUpdate('UPDATE trabajadores SET cajas = cajas + ? WHERE id = ?', [cajas, id]);
          } catch (e) {
            debugPrint('Error registrando cajas (fallback): $e');
          }
        }
      }

      await _loadWorkers();
      setState(() {
        _scannedCode = null;
        _currentWorker = null;
      });
    } catch (e) {
      debugPrint('Error guardando nuevo trabajador: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  Future<void> _addBoxesToExisting(int add) async {
    if (_currentWorker == null) return;
    final id = _currentWorker!['id'] as int;
    try {
      // preferir sumarCajas si existe
      try {
        await db.sumarCajas(id, add);
      } catch (_) {
        // fallback
        final database = await db.database;
        await database.insert('registros', {
          'trabajador_id': id,
          'cantidad': add,
          'hora': DateTime.now().toIso8601String(),
        });
        await database.rawUpdate('UPDATE trabajadores SET cajas = cajas + ? WHERE id = ?', [add, id]);
      }

      final refreshed = await db.getTrabajadorByCodigo(_currentWorker!['codigo'] as String);
      setState(() {
        _currentWorker = refreshed;
        _scannedCode = null;
      });

      await _loadWorkers();
    } catch (e) {
      debugPrint('Error añadiendo cajas: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al añadir cajas: $e')));
    }
  }

  Future<void> _desvincular(int id) async {
    try {
      await db.desvincularQR(id); 
    } catch (_) {
      try {
        await db.desvincularQR(id);
      } catch (e) {
        debugPrint('desvincular no disponible: $e');
      }
    }
    await _loadWorkers();
  }

  Future<void> _deleteTrabajador(int id) async {
    await db.deleteTrabajador(id);
    await _loadWorkers();
  }

  Future<void> _deleteCajaRegistro(int registroId) async {
    try {
      await db.deleteCajaRegistro(registroId);
    } catch (e) {
      debugPrint('deleteCajaRegistro no disponible: $e');
    }
    await _loadWorkers();
  }

  void _onSearchChanged(String q) async {
    final query = q.trim();
    if (query.isEmpty) {
      setState(() => _filtered = List.from(_workers));
      return;
    }
    try {
      final results = await db.buscarTrabajadores(query);
      setState(() => _filtered = results);
    } catch (e) {
      debugPrint('buscarTrabajadores no disponible: $e');
      // fallback local
      setState(() {
        _filtered = _workers.where((w) {
          final nombre = (w['nombre'] ?? '').toString().toLowerCase();
          final codigo = (w['codigo'] ?? '').toString().toLowerCase();
          return nombre.contains(query.toLowerCase()) || codigo.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _showWorkerOptions(Map<String, dynamic> w) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.link_off),
                title: const Text('Desvincular QR'),
                onTap: () async {
                  Navigator.pop(context);
                  await _desvincular(w['id'] as int);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Ver historial de cajas'),
                onTap: () async {
                  Navigator.pop(context);
                  final regs = await db.getRegistrosByTrabajador(w['id'] as int);
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Historial: ${w['nombre']}'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: regs.isEmpty
                            ? const Text('No hay registros')
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: regs.length,
                                itemBuilder: (_, i) {
                                  final r = regs[i];
                                  return ListTile(
                                    title: Text('${r['cantidad']} cajas'),
                                    subtitle: Text(r['hora'] ?? ''),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_forever),
                                      onPressed: () async {
                                        await db.deleteCajaRegistro(r['id'] as int);
                                        Navigator.pop(context);
                                        await _loadWorkers();
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Agregar identificador'),
                onTap: () {
                  Navigator.pop(context);
                  _promptAddIdentificador(w['id'] as int);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Quitar cajas (1/2/3)'),
                onTap: () {
                  Navigator.pop(context);
                  _promptRemoveBoxes(w);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Eliminar cosechero'),
                onTap: () async {
                  Navigator.pop(context);
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('¿Eliminar este cosechero y su historial?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                      ],
                    ),
                  );
                  if (ok == true) await _deleteTrabajador(w['id'] as int);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _promptAddIdentificador(int trabajadorId) {
    final TextEditingController idCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar identificador'),
        content: TextField(controller: idCtrl, decoration: const InputDecoration(labelText: 'Identificador (ej: f23)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final val = idCtrl.text.trim();
              if (val.isNotEmpty) {
                try {
                  await db.agregarIdentificador(trabajadorId, val);
                } catch (e) {
                  debugPrint('Error agregando identificador: $e');
                }
                Navigator.pop(context);
                await _loadWorkers();
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _promptRemoveBoxes(Map<String, dynamic> w) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitar cajas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Cuántas cajas quieres quitar del total?'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final id = w['id'] as int;
                      final actuales = (w['cajas'] ?? 0) as int;
                      final nuevas = (actuales - 1) < 0 ? 0 : actuales - 1;
                      await db.updateCajasById(id, nuevas);
                      await _loadWorkers();
                    },
                    child: const Text('1')),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final id = w['id'] as int;
                      final actuales = (w['cajas'] ?? 0) as int;
                      final nuevas = (actuales - 2) < 0 ? 0 : actuales - 2;
                      await db.updateCajasById(id, nuevas);
                      await _loadWorkers();
                    },
                    child: const Text('2')),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final id = w['id'] as int;
                      final actuales = (w['cajas'] ?? 0) as int;
                      final nuevas = (actuales - 3) < 0 ? 0 : actuales - 3;
                      await db.updateCajasById(id, nuevas);
                      await _loadWorkers();
                    },
                    child: const Text('3')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScannedCard() {
    if (_scannedCode == null) return const SizedBox.shrink();

    if (_currentWorker != null) {
      final name = _currentWorker!['nombre'] ?? '';
      final codigo = _currentWorker!['codigo'] ?? '';
      final cajas = _currentWorker!['cajas'] ?? 0;

      return FutureBuilder<List<String>>(
        future: _getIdentificadoresOf(_currentWorker!['id'] as int),
        builder: (context, snap) {
          final idfs = snap.data ?? [];
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Código: $codigo'),
                const SizedBox(height: 6),
                if (idfs.isNotEmpty) ...[
                  const Text('Identificadores:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: idfs.map((i) => Chip(label: Text(i))).toList(),
                  ),
                  const SizedBox(height: 6),
                ],
                Text('Cajas hasta el momento: $cajas'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(onPressed: () => _addBoxesToExisting(1), child: const Text('+1')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () => _addBoxesToExisting(2), child: const Text('+2')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () => _addBoxesToExisting(3), child: const Text('+3')),
                    const SizedBox(width: 8),
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _scannedCode = null;
                            _currentWorker = null;
                          });
                        },
                        child: const Text('0')),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _promptAddIdentificador(_currentWorker!['id'] as int),
                      child: const Text('Agregar id'),
                    )
                  ],
                )
              ]),
            ),
          );
        },
      );
    } else {
      final TextEditingController nombreCtrl = TextEditingController();
      final TextEditingController codigoCtrl = TextEditingController(text: _scannedCode ?? '');
      final TextEditingController identsCtrl = TextEditingController();

      return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Nuevo cosechero', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 8),
            TextField(controller: codigoCtrl, decoration: const InputDecoration(labelText: 'Código (manual)')),
            const SizedBox(height: 8),
            TextField(
              controller: identsCtrl,
              decoration: const InputDecoration(
                labelText: 'Identificador(s) (separar por coma) - opcional',
                hintText: 'ej: f23, f1',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () => _saveNewWorker(nombreCtrl.text.trim(), codigoCtrl.text.trim(), identsCtrl.text.trim(), 1),
                    child: const Text('1')),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () => _saveNewWorker(nombreCtrl.text.trim(), codigoCtrl.text.trim(), identsCtrl.text.trim(), 2),
                    child: const Text('2')),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () => _saveNewWorker(nombreCtrl.text.trim(), codigoCtrl.text.trim(), identsCtrl.text.trim(), 3),
                    child: const Text('3')),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _scannedCode = null;
                });
              },
              child: const Text('Cancelar'),
            )
          ]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosecheros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final q = await showSearch<String?>(context: context, delegate: _WorkerSearchDelegate(_workers));
              if (q != null) {
                _searchController.text = q;
                _onSearchChanged(q);
              }
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Column(children: [
        if (_scannedCode != null) _buildScannedCard(),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadWorkers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final w = _filtered[i];
                      return Card(
                        child: ListTile(
                          title: Text(w['nombre'] ?? ''),
                          subtitle: Text(w['codigo'] ?? ''),
                          trailing: Text((w['cajas'] ?? 0).toString()),
                          onTap: () => _showWorkerOptions(w),
                        ),
                      );
                    },
                  ),
                ),
        )
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startScanner,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escanear QR'),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('CHERRY BLOCK', style: theme.textTheme.titleLarge),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Cosecheros'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Producción diaria'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const _ProductionView()));
              }),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Volver al menú'),
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ]),
      ),
    );
  }
}

/// Pantalla simple de escaneo (Mobile Scanner)
class _ScannerScreen extends StatefulWidget {
  const _ScannerScreen({super.key});

  @override
  State<_ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<_ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (_scanned) return;
          if (capture.barcodes.isEmpty) return;
          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;
          if (code != null && code.isNotEmpty) {
            _scanned = true;
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}

class _WorkerSearchDelegate extends SearchDelegate<String?> {
  final List<Map<String, dynamic>> workers;
  _WorkerSearchDelegate(this.workers);

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final q = query.trim().toLowerCase();
    final results = workers.where((w) {
      final n = (w['nombre'] ?? '').toString().toLowerCase();
      final c = (w['codigo'] ?? '').toString().toLowerCase();
      return n.contains(q) || c.contains(q);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(results[i]['nombre'] ?? ''),
        subtitle: Text(results[i]['codigo'] ?? ''),
        onTap: () => close(context, results[i]['nombre']),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final q = query.trim().toLowerCase();
    final suggestions = q.isEmpty
        ? workers
        : workers.where((w) {
            final n = (w['nombre'] ?? '').toString().toLowerCase();
            final c = (w['codigo'] ?? '').toString().toLowerCase();
            return n.contains(q) || c.contains(q);
          }).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(suggestions[i]['nombre'] ?? ''),
        subtitle: Text(suggestions[i]['codigo'] ?? ''),
        onTap: () => query = suggestions[i]['nombre'] ?? '',
      ),
    );
  }
}

class _ProductionView extends StatefulWidget {
  const _ProductionView({super.key});

  @override
  State<_ProductionView> createState() => _ProductionViewState();
}

class _ProductionViewState extends State<_ProductionView> {
  final db = DatabaseHelper.instance;
  int _totalBoxes = 0;

  @override
  void initState() {
    super.initState();
    _calcProduction();
  }

  Future<void> _calcProduction() async {
    try {
      final total = await db.getTotalBoxes();
      setState(() => _totalBoxes = total);
    } catch (e) {
      debugPrint('getTotalBoxes no disponible: $e');
      setState(() => _totalBoxes = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bins = _totalBoxes ~/ 24;
    final remainder = _totalBoxes % 24;

    return Scaffold(
      appBar: AppBar(title: const Text('Producción diaria')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Total cajas: $_totalBoxes', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Bins completos (24 cajas): $bins'),
          const SizedBox(height: 8),
          Text('Cajas restantes: $remainder'),
        ]),
      ),
    );
  }
}
