import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

class NFCService {
  Future<String?> readNfcTag() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      return "El NFC no está disponible en este dispositivo";
    }

    final completer = Completer<String?>();

    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          // Verifica el tipo del objeto data
          final dynamic rawData = tag.data;

          if (rawData is! Map<String, dynamic>) {
            // Si no es un Map, mostramos la info completa en texto
            await NfcManager.instance.stopSession();
            completer.complete("Tipo de etiqueta desconocido: ${rawData.runtimeType}");
            return;
          }

          final data = rawData;

          // Intentamos extraer el identificador de varios tipos posibles
          final mifare = data['mifare'] as Map<String, dynamic>?;
          final nfca = data['nfca'] as Map<String, dynamic>?;
          final nfcf = data['nfcf'] as Map<String, dynamic>?;
          final nfcv = data['nfcv'] as Map<String, dynamic>?;

          final idBytes = mifare?['identifier'] ??
              nfca?['identifier'] ??
              nfcf?['identifier'] ??
              nfcv?['identifier'];

          String tagId = idBytes != null
              ? (idBytes as List)
                  .map((b) =>
                      (b as int).toRadixString(16).padLeft(2, '0').toUpperCase())
                  .join()
              : "ID no disponible";

          await NfcManager.instance.stopSession();
          completer.complete(tagId);
        } catch (e) {
          await NfcManager.instance.stopSession();
          completer.completeError("Error al leer la etiqueta: $e");
        }
      },
    );

    return completer.future;
  }
}
