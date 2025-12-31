
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Model/ImageModel.dart';

class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({super.key,required this.imageList,this.title,this.index});
  final List<ImageModel> imageList;
  final int? index;
  final String? title;

  @override
  PhotoViewPageState createState() => PhotoViewPageState();
}

class PhotoViewPageState extends State<PhotoViewPage> {

  List<ImageModel> iList = [];
  late int page = 0;

  void _onPageChanged(int position) {
    page = position;
  }

  PageController pageController = PageController();

  @override
  void initState() {
    iList = widget.imageList;
    pageController = PageController(initialPage: int.parse((widget.index??0).toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: widget.title != ""?AppColors.primaryColor:AppColors.white_00,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title??"",style: AppTextStyle.headlineLarge),
        backgroundColor: widget.title != ""?Colors.white:AppColors.primaryColor,
        titleSpacing: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: PhotoViewGallery.builder(
                  pageController: pageController,
                  itemCount: iList.length,
                  onPageChanged: _onPageChanged,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider((iList[index].showpath??"").toString()),
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },

                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).canvasColor,
                  ),
                  enableRotation: false,
                  loadingBuilder: (context, event) => Center(
                    child: SpinKitCircle(
                      size: 30.0,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}