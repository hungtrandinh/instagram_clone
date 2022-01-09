import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/blocs/edit_profile_blocs/edit_profile_bloc.dart';
import 'package:social_app/blocs/edit_profile_blocs/edit_profile_state.dart';
import 'package:social_app/values/app_asset_editprofile/ediitprofile_textstyle.dart';
import 'package:social_app/values/app_asset_editprofile/editprofile_color.dart';
import 'package:social_app/values/app_assets_icons.dart';

import 'package:social_app/values/app_textstyle.dart';
import 'package:social_app/widgets/dialog.dart';

class AddImageProfile extends StatefulWidget {
  final String path;
  const AddImageProfile({Key? key, required this.path}) : super(key: key);

  @override
  State<AddImageProfile> createState() => _AddImageProfileState(path);
}

class _AddImageProfileState extends State<AddImageProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String path;

  _AddImageProfileState(this.path);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
      if (state.editProfileStatus == EditProfileStatus.submitting) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LoadingDialog(
                  loadingMessage: 'Creating Post',
                ));
      } else if (state.editProfileStatus == EditProfileStatus.success) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
        _formKey.currentState!.reset();
      } else {}
    }, builder: (context, state) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: ColorEditprofile.backgroudColor,
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () async {
                    await context.read<EditProfileBloc>().summit();
                  },
                  child: Text(
                    "Done",
                    style: ProfileTextStyle.doneButon,
                  ))
            ],
            leading: (IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_rounded),
            )),
            elevation: 0,
            backgroundColor: ColorEditprofile.appbarcor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: Text(
                    "Edit Profile",
                    style: AppTextStyle.LoginStyle2,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: state.imagePath == null
                          ? path != 'xxx'
                              ? Image.network(
                                  path,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(AppIcon.avata)
                          : Image.file(
                              state.imagePath!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        _getGallery(context);
                      },
                      child: Text(
                        "Change Profile Photo",
                        style: ProfileTextStyle.addphoto,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "User Name :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          onChanged: (value) => context
                              .read<EditProfileBloc>()
                              .usernameChanged(value),
                          maxLines: 1,
                          maxLength: 20,
                          decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "About Me :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          onChanged: (value) => context
                              .read<EditProfileBloc>()
                              .aboumeChanged(value),
                          maxLines: 1,
                          maxLength: 20,
                          decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "SĐT :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          maxLines: 1,
                          maxLength: 20,
                          decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Địa Chỉ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          maxLines: 1,
                          maxLength: 20,
                          decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  XFile? xFile;
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
          setState(() {
            print(pickedFile.path);
          });
          context
              .read<EditProfileBloc>()
              .profileImageChanged(File(pickedFile.path));
        }
      } catch (e) {}
    }
  }
}
