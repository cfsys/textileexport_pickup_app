import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/DashBoard/ProductCard.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppDrawer.dart';

import '../Controller/CommonApiController.dart';
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
  @override
  void initState() {
    commonApiController.refreshList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        top: false,
        child: Scaffold(
          key: scaffoldKey,
          drawerEnableOpenDragGesture: true,
          drawer: AppDrawer(),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: Image.asset("assets/images/menu.png", height: 25),
            ),
            centerTitle: true,
            toolbarHeight: 70,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.grey_10,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.only(left: 15.0, right: 5.0),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.white_00,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.white_00, width: 1.5),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.white_00,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
            bottom: commonApiController.categoryList.isNotEmpty?PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() => SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: commonApiController.categoryList.length,
                      itemBuilder: (context, index) {
                        return Obx(() => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              if(commonApiController.selectedCategory.value == commonApiController.categoryList[index].id.toString()){
                                commonApiController.selectedCategory.value = "";
                              }else{
                                commonApiController.selectedCategory.value = commonApiController.categoryList[index].id.toString();
                              }
                              commonApiController.refreshList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  color: commonApiController.selectedCategory.value == commonApiController.categoryList[index].id.toString()
                                      ? AppColors.primaryColor
                                      : AppColors.white_00,
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(color: AppColors.primaryColor)
                              ),
                              child: Center(
                                child: Text(
                                  commonApiController.categoryList[index].category_name.toString(),
                                  style: commonApiController.selectedCategory.value == commonApiController.categoryList[index].id.toString()
                                      ? AppTextStyle.labelMedium.copyWith(color: Colors.white)
                                      : AppTextStyle.labelMedium.copyWith(color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ));
                      },
                    ),
                  )),
              ),
            ):null,
          ),
          body: commonApiController.isLoading.value
              ? Center(child: SpinKitThreeBounce(color: AppColors.primaryColor, size: 30))
              : RefreshIndicator(
                  onRefresh: () async {
                    commonApiController.refreshList();
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        (commonApiController.productList.isEmpty && !(commonApiController.isLoading.value))?Center(
                          child: Utils().noItem("No Data Found!"),
                        ):Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: ListView.builder(
                            itemCount: commonApiController.productList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int pIndex) {
                              return ProductCard(pData: commonApiController.productList[pIndex]);
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),

                        commonApiController.isLoading.value? Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Center(
                            child: SpinKitThreeBounce(
                              color: AppColors.primaryColor,
                              size: 30.0,
                            ),
                          ),
                        ):const SizedBox(),

                        const SizedBox(height: 100,),
                      ],
                    ),
                  )
                ),
        ),
      );
    });
  }
}
