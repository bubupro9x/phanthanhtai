
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeView extends StatefulWidget {
  const ScanQrCodeView({Key? key}) : super(key: key);

  @override
  _ScanQrCodeViewState createState() => _ScanQrCodeViewState();
}

class _ScanQrCodeViewState extends State<ScanQrCodeView>
    with TickerProviderStateMixin {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            _buildQrView(context),
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) => QRView(
        key: _qrKey,
        onQRViewCreated: (QRViewController ctrl) async{
          controller = ctrl;
          controller?.scannedDataStream.listen((event) async{
            Navigator.of(context).maybePop(event.code);
          });
        },
        // overlay: CustomQrScannerOverlayShape(
        //     textSpan: TextSpan(
        //         text: LocaleKeys.qr_code_please_move.tr(),
        //         style: AppTextStyle.subHead2
        //             .copyWith(color: AppColors.neutral)),
        //     borderColor: Colors.white,
        //     borderRadius: 5,
        //     borderLength: 10,
        //     borderWidth: 5,
        //     overlayColor: Colors.black87,
        //     cutOutSize: 350),
      );
}
