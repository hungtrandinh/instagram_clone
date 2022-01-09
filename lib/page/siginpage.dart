import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:social_app/blocs/sign_bloc/sign_cubit.dart';
import 'package:social_app/blocs/sign_bloc/sign_state.dart';
import 'package:social_app/page/homepage.dart';

import 'package:social_app/repositories/repositories.dart';

import 'package:social_app/widgets/sign_widget/sign_widgets.dart';

class SiginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
          child: SiginLister()),
    );
  }
}

class SiginLister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: SignWidget(),
    );
  }
}
