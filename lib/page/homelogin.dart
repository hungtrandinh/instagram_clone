import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:social_app/values/app_assets_icons.dart';
import 'package:social_app/values/app_assets_image.dart';
import 'package:social_app/values/app_textstyle.dart';

class HomeLogin extends StatefulWidget {
  const HomeLogin({Key? key}) : super(key: key);
  static Page stateHomeLogin() => const MaterialPage<void>(child: HomeLogin());
  @override
  State<StatefulWidget> createState() {
    return StateHomeLogin();
  }
}

class StateHomeLogin extends State<HomeLogin> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
          image: AssetImage(AppImage.backgroudloginhome),
          fit: BoxFit.cover,
        ))),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Find new",
                        style: GoogleFonts.aBeeZee(
                            textStyle: AppTextStyle.LoginStyle1),
                      ),
                      Text(
                        "friends nearby",
                        style: GoogleFonts.aBeeZee(
                            textStyle: AppTextStyle.LoginStyle1),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "With milions of users all over the world, we gives you the ability to connect with people no matter where you are.",
                      style: GoogleFonts.aBeeZee(
                          textStyle: AppTextStyle.LoginStyle2),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => LoginPage()));
                            },
                            child: Text("Log In",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                )),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("Sign Up",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xffF78361),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)))),
                          ),
                        )
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Or log in with",
                            style: TextStyle(
                                color: Color(0xff4E586E), fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppIcon.facebook),
                              Image.asset(AppIcon.gmail),
                              Image.asset(AppIcon.twicht),
                              SizedBox()
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
