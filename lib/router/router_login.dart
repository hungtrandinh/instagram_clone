import 'package:flutter/material.dart';
// ignore: implementation_imports

import 'package:social_app/blocs/app_login_blocs/app_login_state.dart';
import 'package:social_app/page/homepage.dart';
import 'package:social_app/page/loginpage.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
