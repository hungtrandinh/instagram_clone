import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:social_app/blocs/login_blocs/login_blocs.dart';
import 'package:social_app/blocs/login_blocs/login_state.dart';
import 'package:social_app/page/siginpage.dart';
import 'package:social_app/values/app_assets_image.dart';
import 'package:social_app/values/app_textstyle.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Stack(children: [
          Container(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(AppImage.backgroudloginpage))),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 1 / 6,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back",
                    style: AppTextStyle.LoginStyle3,
                  ),
                  Text(
                    "Login to you accout",
                    style: AppTextStyle.LoginStyle4,
                  )
                ],
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 1 / 3,
            left: 20,
            right: 20,
            child: Container(
              height: MediaQuery.of(context).size.height * 1 / 2,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    keyboardType: TextInputType.text,
                    onChanged: (email) {
                      return context.read<LoginCubit>().emailChanged(email);
                    },
                    decoration: InputDecoration(
                        errorText: state.email.invalid ? "invalid email" : null,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(16),
                        fillColor: Colors.white24),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onChanged: (password) {
                      return context
                          .read<LoginCubit>()
                          .passwordChanged(password);
                    },
                    decoration: InputDecoration(
                        errorText:
                            state.password.invalid ? "invalid password" : null,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(16),
                        fillColor: Colors.white24),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  state.status != FormzStatus.submissionInProgress
                      ? SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<LoginCubit>()
                                    .logInWithCredentials();
                                print("s");
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffF78361),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              child: Text(
                                "Login",
                                style: AppTextStyle.LoginStyle2,
                              )),
                        )
                      : Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SiginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffF78361),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        child: Text(
                          "SIGN UP",
                          style: AppTextStyle.LoginStyle2,
                        )),
                  )
                ],
              ),
            ),
          )
        ]);
      },
    );
  }
}
