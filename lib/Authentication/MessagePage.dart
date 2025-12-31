import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';

import '../Library/AppColors.dart';
import 'package:get/get.dart';

import '../Library/MyNavigator.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key,required this.is_kys, required this.remark}) : super(key: key);
  final String is_kys;
  final String remark;


  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 5,
          title: Text("Status",style: AppTextStyle.headlineLarge,),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                accountName: null,
                accountEmail: null,
              ),

              ListTile(
                onTap: () {
                  MyNavigator.goToSignOut(context);
                },
                leading: const Icon(Icons.logout_rounded,
                    color: AppColors.black, size: 30),
                title: Text("Logout", style: AppTextStyle.labelMedium),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Column(
                    children: [
                      const SizedBox(
                        height: 60,
                        child: DottedLine(
                          direction: Axis.vertical,
                          dashColor: AppColors.green_00,
                          lineThickness: 4,
                          dashLength: 8,
                          dashGapLength: 5,
                          dashRadius: 5,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Image.asset('assets/images/checked.png',height: 70,),
                      ),

                      Text('Form Filled',style: AppTextStyle.headlineLarge.copyWith(color: AppColors.green_00),),

                      const SizedBox(height: 8,),
                    ],
                  ),

                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: DottedLine(
                          direction: Axis.vertical,
                          dashColor: widget.is_kys.toString() == "2"?AppColors.green_00:AppColors.red_55,
                          lineThickness: 4,
                          dashLength: 8,
                          dashGapLength: 5,
                          dashRadius: 5,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: widget.is_kys.toString() == "2" ? Image.asset('assets/images/checked.png',height: 70,)
                            : widget.is_kys.toString() == "3" ? Image.asset('assets/images/cancel.png',height: 70,)
                            :Image.asset('assets/images/lock.png',height: 70,),
                      ),

                      widget.is_kys.toString() == "2"?Text('Management Approve Successful',style: AppTextStyle.headlineMedium.copyWith(fontSize: 18,color: AppColors.green_00))
                          :widget.is_kys.toString() == "1"?Text("Management Approval Pending",style: AppTextStyle.headlineMedium.copyWith(fontSize: 18,color: AppColors.grey_09),)
                          :Text("Management Approval Rejected",style: AppTextStyle.headlineMedium.copyWith(fontSize: 18,color: AppColors.red_55),),



                      const SizedBox(height: 8,),
                    ],
                  ),



                  const SizedBox(height: 50,),

                  Visibility(
                    visible: widget.is_kys.toString() == '3',
                    child: Column(
                      children: [

                        const SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Reject Remark :',style: AppTextStyle.headlineLarge,),
                            ],
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                                child: Text(widget.remark.toString(),style: AppTextStyle.headlineLarge.copyWith(color: AppColors.red_55),textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        )
    );
  }
}
