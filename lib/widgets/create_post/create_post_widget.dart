import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/blocs/post_bloc/post_cubit.dart';
import 'package:social_app/blocs/post_bloc/post_state.dart';
import 'package:social_app/values/app_asset_editprofile/ediitprofile_textstyle.dart';
import 'package:social_app/values/app_asset_editprofile/editprofile_color.dart';
import 'package:social_app/values/app_assets_image.dart';
import 'package:social_app/values/app_textstyle.dart';
import 'package:social_app/widgets/dialog.dart';

class CreatePostWidget extends StatefulWidget {
  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(listener: (context, state) {
      if (state.status == StatusPost.success) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
        _formKey.currentState!.reset();
        context.read<PostCubit>().reset();
      } else if (state.status == StatusPost.submitting) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LoadingDialog(
            loadingMessage: 'Creating Post',
          ),
        );
      } else if (state.status == StatusPost.failure) {}
    }, builder: (context, state) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorEditprofile.backgroudColor,
          appBar: AppBar(
            backgroundColor: ColorEditprofile.backgroudColor,
            elevation: 0,
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<PostCubit>().summit();
                  },
                  child: Text(
                    "Done",
                    style: ProfileTextStyle.doneButon,
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state.status == StatusPost.submitting)
                  LinearProgressIndicator(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: xFile == null
                      ? Image.asset(AppImage.addimage, fit: BoxFit.fill)
                      : Image.file(xFile!, fit: BoxFit.fill),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    onChanged: (caption) =>
                        context.read<PostCubit>().CaptionChange(caption),
                    maxLines: 1,
                    maxLength: 20,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        labelText: "Bạn đang nghĩ gì thế?",
                        prefixStyle: AppTextStyle.LoginStyle4,
                        helperStyle: AppTextStyle.LoginStyle4,
                        labelStyle: AppTextStyle.LoginStyle4,
                        border: InputBorder.none,
                        fillColor: ColorEditprofile.backgroudColor,
                        filled: true),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 7 / 9,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffF78361),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          _getGallery(context);
                        },
                        child: Text("Thêm ảnh")),
                  ),
                )
              ],
            ),
          ));
    });
  }

  File? xFile;

  Future _getGallery(BuildContext context) async {
    ImagePicker _imagePicker = ImagePicker();
    if (!mounted) {
      return;
    } else {
      try {
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 500,
          maxHeight: 500,
          imageQuality: 100,
        );
        if (pickedFile != null) {
          cropimage(pickedFile);
        }
      } catch (e) {}
    }
  }

  Future<XFile?> cropimage(XFile file) async {
    File? _cropper = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 16),
        compressQuality: 100,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      xFile = _cropper;
    });
    context.read<PostCubit>().PostImageChange(File(_cropper!.path));
  }
}
