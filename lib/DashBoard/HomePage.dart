import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:textile_exporter_admin/DashBoard/VendorCard.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppDrawer.dart';

import '../Controller/CommonApiController.dart';
import '../Library/AppStorage.dart';
import '../Library/Utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CommonApiController commonApiController = Get.put(CommonApiController());

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
  setBlankData()async{
    await Future.delayed(Duration.zero,() async{
      var uid = await AppStorage.getData("uid") ?? "";
      var chkUid = commonApiController.userList.where((element) => element['id'] == uid).toList();
      if(chkUid.isNotEmpty){
        commonApiController.selectedUser.value = uid.toString();
      }else{
        commonApiController.selectedUser.value = "";
      }
      commonApiController.selectedCategory.value = "All";
      commonApiController.refreshList();
    },);

  }
  @override
  void initState() {
    setBlankData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            drawerEnableOpenDragGesture: true,
            drawer: AppDrawer(),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(Icons.menu_rounded,color: AppColors.white_00,size: 25,),
              ),
              centerTitle: true,
              toolbarHeight: 70,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.primaryColor,
                statusBarIconBrightness: Brightness.light,
              ),
              backgroundColor: AppColors.primaryColor,
              title: Padding(
                padding: const EdgeInsets.only(right: 10,),
                child: TextFormField(
                  style: AppTextStyle.inputText,
                  controller: commonApiController.searchController.value,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: AppColors.black,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (val) {
                    commonApiController.searchController.value.text = val.toString();
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () async {
                      commonApiController.refreshList();
                    });
                  },
                  onChanged: (val) async {
                    commonApiController.searchController.value.text = val.toString();
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () async {
                      commonApiController.refreshList();
                    });
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Search...",
                    isDense: true,
                    hintStyle: AppTextStyle.textHint,
                    filled: true,
                    fillColor: AppColors.white_00,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    suffixIcon: IconButton(
                        onPressed: () {
                          commonApiController.searchController.value.text = "";
                          commonApiController.refreshList();
                        },
                        style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                        icon: Icon(Icons.close_rounded,color: AppColors.primaryColor,size: 20,)
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.white_00,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.white_00, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.white_00,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:14.0,right: 10),
                        child: DropdownButton<String>(
                          value: commonApiController.selectedUser.value.trim().isEmpty?null:commonApiController.selectedUser.value,
                          dropdownColor: AppColors.primaryColor,
                          hint: Text("Select Pickup Person",style: AppTextStyle.textHint.copyWith(color: AppColors.white_00)),
                          borderRadius: BorderRadius.circular(0),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,color: AppColors.white_00,),
                          iconSize: 30,
                          elevation: 16,
                          style: AppTextStyle.labelMedium.copyWith(color: AppColors.white_00),
                          onChanged: (String? newValue) {
                            setState(() {
                              commonApiController.selectedUser.value = newValue.toString();
                              commonApiController.refreshList();
                            });
                          },
                          items: commonApiController.userList.map((dynamic value) {
                            return DropdownMenuItem(
                              value: value['id'].toString(),
                              child: Text(value['username'].toString(),style: AppTextStyle.labelMedium.copyWith(color: AppColors.white_00)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )
              ),
              // bottom: commonApiController.categoryList.isNotEmpty?PreferredSize(
              //   preferredSize: const Size.fromHeight(40),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              //     child: Obx(() => SizedBox(
              //         height: 35,
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: commonApiController.categoryList.length,
              //           itemBuilder: (context, index) {
              //             return Obx(() => Padding(
              //               padding: const EdgeInsets.only(right: 10),
              //               child: GestureDetector(
              //                 onTap: () {
              //                   if(commonApiController.selectedCategory.value == commonApiController.categoryList[index].toString()){
              //                     commonApiController.selectedCategory.value = "";
              //                   }else{
              //                     commonApiController.selectedCategory.value = commonApiController.categoryList[index].toString();
              //                   }
              //                   commonApiController.refreshList();
              //                 },
              //                 child: Container(
              //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              //                   decoration: BoxDecoration(
              //                       color: commonApiController.selectedCategory.value == commonApiController.categoryList[index].toString()
              //                           ? AppColors.primaryColor
              //                           : AppColors.white_00,
              //                       borderRadius: BorderRadius.circular(30),
              //                   ),
              //                   child: Center(
              //                     child: Text(
              //                       commonApiController.categoryList[index].toString(),
              //                       style: commonApiController.selectedCategory.value == commonApiController.categoryList[index].toString()
              //                           ? AppTextStyle.labelMedium.copyWith(color: Colors.white)
              //                           : AppTextStyle.labelMedium.copyWith(color: AppColors.grey_10),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ));
              //           },
              //         ),
              //       )),
              //   ),
              // ):null,
            ),
            body: commonApiController.isLoading.value
                ? Center(
              child: SpinKitThreeBounce(
                color: AppColors.primaryColor,
                size: 30,
              ),
            )
                : RefreshIndicator(
              onRefresh: () async {
                commonApiController.refreshList();
                setState(() {});
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [

                  if (commonApiController.productList.isEmpty &&
                      !commonApiController.isLoading.value)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Utils().noItem("No Data Found!"),
                      ),
                    )

                  else
                    SliverPadding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return VendorCard(
                              pData: commonApiController.productList[index],
                            );
                          },
                          childCount:
                          commonApiController.productList.length,
                        ),
                      ),
                    ),

                  if (commonApiController.isLoading.value)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: AppColors.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            )
          ),
        ),
      );
    });
  }
}
