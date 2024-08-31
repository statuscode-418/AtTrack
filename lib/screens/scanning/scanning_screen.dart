// ignore_for_file: use_build_context_synchronously

import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/checkpoint_stamp.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/services/firestore_storage/firestore_db_exceptions.dart';
import 'package:attrack/services/qr_service/qr_parser.dart';
import 'package:attrack/shared/snackbar/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class ScanningScreen extends StatefulWidget {
  final CheckpointModel checkpointModel;
  final EventModel eventModel;
  final DBModel db;
  const ScanningScreen({
    super.key,
    required this.checkpointModel,
    required this.eventModel,
    required this.db,
  });

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late BarcodeCapture result;
  late final MobileScannerController _mobileScannerController;

  @override
  void initState() {
    _mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    super.initState();
  }

  @override
  void dispose() {
    _mobileScannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture scan) {
    var codes = scan.barcodes;
    if (codes.isEmpty) {
      return;
    }
    for (var code in codes) {
      var raw = code.rawValue;
      if (raw == null) {
        continue;
      }
      try {
        String participantCode = QrParser.parseHost(raw);
        var stampId = const Uuid().v4();
        var checkpointStamp = CheckpointStamp(
          stampId: stampId,
          participantCode: participantCode,
          checkpointId: widget.checkpointModel.checkpointId,
          eventId: widget.checkpointModel.eventId,
          uid: widget.eventModel.uid,
          createdAt: DateTime.now(),
        );

        try {
          widget.db.createCheckpointStamp(checkpointStamp);
        } catch (e) {
          throw GenericDbException(e.toString());
        }
      } catch (e) {
        showSnackbar(context, 'Invalid QR Code', type: SnackbarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scanning'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: MobileScanner(
                  controller: _mobileScannerController,
                  onDetect: _onDetect,
                ),
              ),
            )
          ],
        ));
  }
}
