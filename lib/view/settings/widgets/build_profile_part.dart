import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_cse_community/constant/constant.dart';
import 'package:lu_cse_community/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class BuildProfilePart extends StatefulWidget {
  BuildProfilePart({
    Key? key,
    required this.isViewMode,
    required this.name,
    required this.email,
    required this.isViewer,
    required this.url,
  }) : super(key: key);
  bool isViewMode;
  bool isViewer;
  String name;
  String email;
  String url;

  @override
  _BuildProfilePartState createState() => _BuildProfilePartState();
}

class _BuildProfilePartState extends State<BuildProfilePart> {
  final picker = ImagePicker();

  Future pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            statusBarColor: nevColor,
            toolbarColor: nevColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
        );
        if (croppedFile != null) {
          Provider.of<ProfileProvider>(context, listen: false)
              .updateProfileUrl(croppedFile, context);
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isViewer);
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120.w,
                width: 120.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.09),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.01),
                          width: 2.0,
                        ),
                      ),
                      height: widget.isViewMode ? 90.w : 110.w,
                      width: widget.isViewMode ? 90.w : 110.w,
                      child: widget.isViewer
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: widget.url != ""
                                  ? FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: 'assets/profile.jpg',
                                      image: widget.url)
                                  : Image.asset(
                                      "assets/profile.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: provider.profileUrl != ""
                                  ? FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: 'assets/profile.jpg',
                                      image: provider.profileUrl,
                                    )
                                  : Image.asset(
                                      "assets/profile.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                    ),
                    if (!widget.isViewMode)
                      Positioned(
                        right: 10.w,
                        bottom: 11.h,
                        child: InkWell(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                              height: 24.w,
                              width: 24.w,
                              padding: EdgeInsets.all(3.sp),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: mainColor,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                widget.isViewMode ? widget.name : provider.profileName,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: widget.isViewMode ? 20.sp : 26.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.isViewMode ? widget.email : provider.email,
                style: GoogleFonts.inter(
                    color: const Color(0xff666666),
                    fontSize: widget.isViewMode ? 12.sp : 13.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );
      },
    );
  }
}
