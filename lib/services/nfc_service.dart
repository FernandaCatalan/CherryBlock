import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// Resultado del escaneo NFC con información detallada
class NFCScanResult {
  final NfcTag tag;
  final DateTime timestamp;
  String tagType;
  String uid;
  Map<String, dynamic> data;

  NFCScanResult({
    required this.tag,
    required this.timestamp,
    required this.tagType,
    required this.uid,
    required this.data,
  });
}

/// Servicio para manejar lectura NFC
class NFCService {
  bool _isScanning = false;
  
  get Ndef => null;

  /// Inicia la lectura NFC y devuelve el UID o texto encontrado
  Future<String?> readNfcTag() async {
    if (_isScanning) return null;

    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      return "El NFC no está disponible en este dispositivo";
    }

    final completer = Completer<String?>();
    _isScanning = true;

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        onDiscovered: (NfcTag tag) async {
          try {
            final result = await _readTagData(tag);
            final ndefText = _extractNdefText(result);

            String output;
            if (ndefText != null && ndefText.isNotEmpty) {
              output = ndefText;
            } else if (result.uid.isNotEmpty) {
              output = result.uid;
            } else {
              output = "Etiqueta NFC detectada sin datos legibles";
            }

            completer.complete(output);
          } catch (e) {
            completer.completeError("Error durante la lectura: $e");
          } finally {
            await NfcManager.instance.stopSession();
            _isScanning = false;
          }
        },
      );
    } catch (e) {
      completer.completeError("No se pudo iniciar la sesión NFC: $e");
      _isScanning = false;
    }

    return completer.future;
  }

  /// Extrae el texto NDEF si existe
  String? _extractNdefText(NFCScanResult result) {
    final ndef = result.data['ndef'];
    if (ndef is Map && ndef['records'] is List && ndef['records'].isNotEmpty) {
      final record = ndef['records'][0];
      if (record is Map &&
          record['type'] != null &&
          record['payload'] != null) {
        final typeBytes = record['type'];
        final payloadBytes = record['payload'];
        if (typeBytes is List &&
            String.fromCharCodes(typeBytes as Iterable<int>) == 'T' &&
            payloadBytes is List) {
          // Ensure the dynamic list is treated as a List<int> before creating Uint8List
          final payload = Uint8List.fromList(payloadBytes.cast<int>());
          if (payload.isEmpty) return null;

          final status = payload[0];
          final isUtf16 = (status & 0x80) != 0;
          final langLen = status & 0x3F;

          if (payload.length < 1 + langLen) return null;

          final textBytes = payload.sublist(1 + langLen);
          try {
            return isUtf16
                ? String.fromCharCodes(textBytes)
                : utf8.decode(textBytes);
          } catch (_) {
            return String.fromCharCodes(textBytes);
          }
        }
      }
    }
    return null;
  }

  /// Lee datos completos del tag, incluyendo UID y registros NDEF
  Future<NFCScanResult> _readTagData(NfcTag tag) async {
    final result = NFCScanResult(
      tag: tag,
      timestamp: DateTime.now(),
      tagType: 'Unknown',
      uid: 'Unknown',
      data: {},
    );

    try {
      final raw = tag.data;

      // 🔹 Extraer UID de distintas variantes posibles
      List<int>? idBytes;
      if (raw is Map && raw['id'] is List) {
        idBytes = (raw['id'] as List).cast<int>();
      } else if (raw is Map &&
          raw['nfca'] is Map &&
          raw['nfca']['identifier'] is List) {
        idBytes = (raw['nfca']['identifier'] as List).cast<int>();
      } else if (raw is Map &&
          raw['mifareclassic'] is Map &&
          raw['mifareclassic']['identifier'] is List) {
        idBytes = (raw['mifareclassic']['identifier'] as List).cast<int>();
      }

      if (idBytes != null) {
        final uid = idBytes
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        result.uid = uid;
        result.data['UID'] = uid;
      }

      // 🔹 Intentar leer mensaje NDEF
      final ndef = Ndef.from(tag);
      if (ndef != null) {
        result.tagType = 'NDEF';
        if (ndef.cachedMessage != null) {
          final message = ndef.cachedMessage!;
          result.data['ndef'] = {
            'records': message.records.map((record) {
              return {
                'type': record.type,
                'payload': record.payload,
                'tnf': record.typeNameFormat.index,
                'id': record.identifier,
              };
            }).toList(),
          };
        } else {
          result.data['ndef'] = {'records': <Map<String, dynamic>>[]};
        }
      } else {
        result.tagType = 'Non-NDEF';
      }
    } catch (e) {
      result.data['error'] = e.toString();
    }

    return result;
  }
}
