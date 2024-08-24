import 'package:chat/app/pages.dart' as app;
import 'package:chat/futures/app/app.view.dart';
import 'package:chat/futures/auth/auth.view.dart';
import 'package:chat/futures/auth_forgot/auth_forgot.view.dart';
import 'package:chat/futures/auth_login/auth_login.view.dart';
import 'package:chat/futures/auth_reigster/auth_register.view.dart';
import 'package:chat/futures/search_filter/search_filter.view.dart';
import 'package:chat/futures/splash/splash.view.dart';
import 'package:get/get.dart';

List<GetPage> pages = [
  ...app.pages,
  GetPage(name: '/', page: () => const SplashView()),
  GetPage(name: '/auth', page: () => const AuthView()),
  GetPage(name: '/auth/login', page: () => const AuthLoginView()),
  GetPage(name: '/auth/forgot', page: () => const AuthForgotView()),
  GetPage(name: '/auth/register', page: () => const AuthRegisterView()),
  GetPage(name: '/app', page: () => const AppView()),
  GetPage(name: '/app/search/filter', page: () => const SearchFilterView()),
];
