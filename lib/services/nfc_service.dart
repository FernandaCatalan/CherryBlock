import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

class NFCService {
  Future<String> readNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      return "El NFC no está disponible en este dispositivo";
    }

    final completer = Completer<String>();

    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693, 
      },
      onDiscovered: (NfcTag tag) async {
        try {
          final tagData = tag.data;
          await NfcManager.instance.stopSession();
          completer.complete(tagData.toString());
        } catch (e) {
          await NfcManager.instance.stopSession();
          completer.completeError("Error al leer la etiqueta: $e");
        }
      },
    );

    return completer.future;
  }
}
