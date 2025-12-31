
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppConstant.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Library/ManageStore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'Utils.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {


  String userName = '';
  String qrWallet = '';
  getUserName()async{
    userName = await AppStorage.getData('username');
    qrWallet = await AppStorage.getData('WalletQr');
    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  ScreenshotController screenshotController = ScreenshotController();

  shareFile() async {
    try {
      ShareResult shareResult;
      final image = await screenshotController.capture();
      print('SSSSSSSSSSSSSSSSSS 222222222 $image');
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/${DateTime.now().microsecondsSinceEpoch}_token.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);
        print('SSSSSSSSSSSSSSSSSS 3333333');
        shareResult = await Share.shareXFiles(
          [XFile(imagePath)],
          subject: 'Token Screenshot',
        );
        print('SSSSSSSSSSSSSSSSSS 4444 $shareResult');
        if(shareResult.status == ShareResultStatus.success){
          Navigator.of(context).pushNamed('/Dashboard');
        }
      }
    } catch (e) {
      print('SSSSSSSSSSSSSSSSSS ***** $e');
      Utils().showSnack(context: context, msg: "Something went wrong", snackType: SnackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: AppColors.black,
          ),
        ),
        title: Text(
          'Scan QR',
          style: AppTextStyle.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white_40,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColors.grey_09,
                                    shape: BoxShape.circle
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.person),
                                )
                            ),
                            SizedBox(width: 10,),
                            Text(userName,style: AppTextStyle.headlineVeryVeryLarge),
                          ],
                        ),
                        QrImageView(
                          data: qrWallet,
                          version: QrVersions.auto,
                          size: 275.0,
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () async{
                            await Clipboard.setData(ClipboardData(text: qrWallet.toString()));
                            Utils().showSnackGetX(msg: "Copied to Clipboard", snackType: SnackType.common);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.grey_09,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 30,left: 20,bottom: 5,top: 5),
                                  child: Text(qrWallet.toString(),style: AppTextStyle.displaySmall,),
                                ),
                                Positioned(
                                  right: 5,
                                  child: Icon(Icons.copy_rounded,color: AppColors.black,size: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Scan For Money Transfer",style: AppTextStyle.labelMedium),
                            SizedBox(width: 5,),
                            InkWell(
                              onTap: (){
                                print('SSSSSSSSSSSSSSSSSS 1111111');
                                shareFile();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.grey_09,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                                    child: Icon(Icons.share,size: 15,),
                                    // child: Text('Share QR',style: AppTextStyle.displayMedium,),
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 35,
                              width: 35,
                            ),
                            SizedBox(width: 10,),
                            Text(AppConstant.appName,style: AppTextStyle.headlineVeryVeryLarge),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
