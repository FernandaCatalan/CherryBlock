import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cherry_block/services/database_helper.dart';

class ExcelExportService {
  static Future<void> exportToExcel() async {
    try {
      final db = DatabaseHelper.instance;
      final data = await db.getAllDataForExport();
      
      // Crear Excel
      var excel = Excel.createExcel();
      
      // ===== HOJA 1: RESUMEN DE COSECHEROS =====
      String sheetName1 = 'Resumen';
      Sheet sheetResumen = excel[sheetName1];
      
      // Encabezados
      sheetResumen.cell(CellIndex.indexByString("A1")).value = TextCellValue('Nombre');
      sheetResumen.cell(CellIndex.indexByString("B1")).value = TextCellValue('Codigo QR');
      sheetResumen.cell(CellIndex.indexByString("C1")).value = TextCellValue('Identificadores');
      sheetResumen.cell(CellIndex.indexByString("D1")).value = TextCellValue('Total Cajas');
      
      // Datos
      int row = 2;
      for (var item in data) {
        final trabajador = item['trabajador'] as Map<String, dynamic>;
        final identificadores = item['identificadores'] as String;
        
        sheetResumen.cell(CellIndex.indexByString("A$row")).value = TextCellValue(trabajador['nombre']?.toString() ?? '');
        sheetResumen.cell(CellIndex.indexByString("B$row")).value = TextCellValue(trabajador['codigo']?.toString() ?? '');
        sheetResumen.cell(CellIndex.indexByString("C$row")).value = TextCellValue(identificadores);
        sheetResumen.cell(CellIndex.indexByString("D$row")).value = IntCellValue(trabajador['cajas'] ?? 0);
        
        row++;
      }
      
      // ===== HOJA 2: HISTORIAL DETALLADO =====
      String sheetName2 = 'Historial';
      Sheet sheetHistorial = excel[sheetName2];
      
      sheetHistorial.cell(CellIndex.indexByString("A1")).value = TextCellValue('Nombre');
      sheetHistorial.cell(CellIndex.indexByString("B1")).value = TextCellValue('Identificadores');
      sheetHistorial.cell(CellIndex.indexByString("C1")).value = TextCellValue('Cantidad Cajas');
      sheetHistorial.cell(CellIndex.indexByString("D1")).value = TextCellValue('Fecha y Hora');
      
      row = 2;
      for (var item in data) {
        final trabajador = item['trabajador'] as Map<String, dynamic>;
        final identificadores = item['identificadores'] as String;
        final registros = item['registros'] as List<Map<String, dynamic>>;
        
        for (var registro in registros) {
          final hora = registro['hora']?.toString() ?? '';
          final fecha = hora.isNotEmpty ? _formatearFecha(hora) : '';
          
          sheetHistorial.cell(CellIndex.indexByString("A$row")).value = TextCellValue(trabajador['nombre']?.toString() ?? '');
          sheetHistorial.cell(CellIndex.indexByString("B$row")).value = TextCellValue(identificadores);
          sheetHistorial.cell(CellIndex.indexByString("C$row")).value = IntCellValue(registro['cantidad'] ?? 0);
          sheetHistorial.cell(CellIndex.indexByString("D$row")).value = TextCellValue(fecha);
          
          row++;
        }
      }
      
      // ===== HOJA 3: PRODUCCIÓN TOTAL =====
      String sheetName3 = 'Produccion';
      Sheet sheetProduccion = excel[sheetName3];
      
      final totalCajas = await db.getTotalBoxes();
      final bins = totalCajas ~/ 24;
      final restantes = totalCajas % 24;
      
      sheetProduccion.cell(CellIndex.indexByString("A1")).value = TextCellValue('RESUMEN DE PRODUCCION');
      sheetProduccion.cell(CellIndex.indexByString("A3")).value = TextCellValue('Total Cajas:');
      sheetProduccion.cell(CellIndex.indexByString("B3")).value = IntCellValue(totalCajas);
      sheetProduccion.cell(CellIndex.indexByString("A4")).value = TextCellValue('Bins Completos:');
      sheetProduccion.cell(CellIndex.indexByString("B4")).value = IntCellValue(bins);
      sheetProduccion.cell(CellIndex.indexByString("A5")).value = TextCellValue('Cajas Extras:');
      sheetProduccion.cell(CellIndex.indexByString("B5")).value = IntCellValue(restantes);
      
      // Eliminar Sheet1 por defecto
      excel.delete('Sheet1');
      
      // Guardar archivo
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final date = DateTime.now();
      final filePath = '${directory.path}/Reporte_${date.day.toString().padLeft(2,'0')}_'
      '${date.month.toString().padLeft(2,'0')}_${date.year}.xlsx';
      
      print('Guardando archivo en: $filePath');
      
      var fileBytes = excel.encode();
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        
        print('Archivo guardado exitosamente');
        print('Tamaño: ${file.lengthSync()} bytes');
        
        // Compartir
        await Share.shareXFiles(
          [XFile(filePath)],
          subject: 'Reporte Cherry Block',
          text: 'Reporte de cosecheros y produccion',
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack: $stackTrace');
      rethrow;
    }
  }
  
  static String _formatearFecha(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }
}