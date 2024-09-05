// ignore_for_file: use_build_context_synchronously

import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/shared/snackbar/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'scanning_view_model.dart';

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
  late MobileScannerController _mobileScannerController;

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
      final viewModel = Provider.of<ScanningViewModel>(context, listen: false);
      viewModel.processScan(raw).catchError((e) {
        showSnackbar(context, 'Invalid qr code', type: SnackbarType.error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScanningViewModel(
        checkpointModel: widget.checkpointModel,
        eventModel: widget.eventModel,
        db: widget.db,
      ),
      child: Scaffold(
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
        ),
      ),
    );
  }
}
