
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'AppColors.dart';
import 'AppTextStyle.dart';


class QrView extends StatefulWidget {
  const QrView({this.onChange,required this.top,required this.bottom,required this.isSound, this.isPopUpOpen});

  final ValueChanged<dynamic>? onChange;
  final double top;
  final double bottom;
  final bool isSound;
  final bool? isPopUpOpen;


  @override
  _QrViewState createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  MobileScannerController cameraController =  MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates
  );

  @override
  void initState(){
    super.initState();
  }
  DateTime? lastScan;

  onScan(capture)async{
    print('11111111111111111111111');
    print(widget.isPopUpOpen);
    if((widget.isPopUpOpen??false) == false){
      final List<Barcode> barcodes = capture.barcodes;
      String code = "";
      for (final barcode in barcodes) {
        code = barcode.rawValue!;
      }
      final currentScan = DateTime.now();
      if ((lastScan == null) || (currentScan.difference(lastScan!) > const Duration(seconds: 2))) {
        lastScan = currentScan;
        if(code != "") {
          widget.isSound ? AudioPlayer().play(AssetSource("sound/qr_sound.mp3"))
              : const SizedBox();

          widget.onChange!(code);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
      MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          onScan(capture);
        }
      ),

      Padding(
        padding: EdgeInsets.only(top:widget.top+5.0,bottom: widget.bottom+5.0,right: 5.0,left: 5.0),
        child: Center(
          child: Image.asset("assets/images/qr_scan.png")
        ),
      ),

      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.grey_09,
            ),
            child: InkWell(
              onTap: ()async{
                BarcodeCapture? _barcodeCapture;

                final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

                if (!mounted) {
                  return;
                }

                if (file == null) {
                  setState(() {
                    _barcodeCapture = null;
                  });
                  return;
                }

                final BarcodeCapture? barcodeCapture = await cameraController.analyzeImage(file.path);

                if (mounted) {
                  setState(() {
                    _barcodeCapture = barcodeCapture;
                  });
                }

                onScan(_barcodeCapture);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_rounded,color: AppColors.black,size: 18,),
                    SizedBox(width: 5.0,),
                    Text("Choose QR From Gallery",style: AppTextStyle.bodySmall,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
    );
  }
}




