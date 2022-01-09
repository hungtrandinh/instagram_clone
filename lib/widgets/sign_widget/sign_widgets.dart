import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:social_app/blocs/sign_bloc/sign_cubit.dart';
import 'package:social_app/blocs/sign_bloc/sign_state.dart';
import 'package:social_app/values/app_assets_image.dart';
import 'package:social_app/values/app_textstyle.dart';

class SignWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(AppImage.backgroudsignpage))),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 1 / 6,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "Create an account",
                          style: AppTextStyle.LoginStyle3,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        onChanged: (name) =>
                            context.read<SignUpCubit>().changedName(name),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'UserName',
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
                        onChanged: (email) =>
                            context.read<SignUpCubit>().emailChanged(email),
                        decoration: InputDecoration(
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
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        onChanged: (pasword) => context
                            .read<SignUpCubit>()
                            .passwordChanged(pasword),
                        decoration: InputDecoration(
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
                      TextField(
                        obscureText: true,
                        onChanged: (confimpassword) => context
                            .read<SignUpCubit>()
                            .confirmedPasswordChanged(confimpassword),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Re-enter password',
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
                      SizedBox(height: 50, child: _SignUpButton())
                    ],
                  ),
                ))
          ],
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Center(child: const CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () {
                  context.read<SignUpCubit>().signUpFormSubmitted();
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xffF78361),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                child: Text(
                  "Sigin",
                  style: AppTextStyle.LoginStyle2,
                ));
      },
    );
  }
}
