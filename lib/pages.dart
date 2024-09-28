import 'package:chat/app/pages.dart' as app;
import 'package:chat/futures/500/500.view.dart';
import 'package:chat/futures/account_delete_leave/account_delete_leave.view.dart';
import 'package:chat/futures/account_notification/account_notification.view.dart';
import 'package:chat/futures/account_security/account_security.view.dart';
import 'package:chat/futures/account_verify_phone/account_verify_phone.view.dart';
import 'package:chat/futures/app/app.view.dart';
import 'package:chat/futures/auth/auth.view.dart';
import 'package:chat/futures/auth_forgot/auth_forgot.view.dart';
import 'package:chat/futures/auth_login/auth_login.view.dart';
import 'package:chat/futures/auth_reigster/auth_register.view.dart';
import 'package:chat/futures/blocks/blocks.view.dart';
import 'package:chat/futures/contact/contact.view.dart';
import 'package:chat/futures/cropper/cropper.view.dart';
import 'package:chat/futures/earning_income/earning_income.view.dart';
import 'package:chat/futures/favorites/favorites.view.dart';
import 'package:chat/futures/page/page.view.dart';
import 'package:chat/futures/payment/payment.view.dart';
import 'package:chat/futures/profile/profile.view.dart';
import 'package:chat/futures/profile_edit/profile_edit.view.dart';
import 'package:chat/futures/purchase/one-step.view.dart';
import 'package:chat/futures/search/search.view.dart';
import 'package:chat/futures/splash/splash.view.dart';
import 'package:chat/futures/transactions/transactions.view.dart';
import 'package:get/get.dart';

List<GetPage> pages = [
  ...app.pages,
  GetPage(name: '/500', page: () => const Error500View()),
  GetPage(name: '/', page: () => const SplashView()),
  GetPage(name: '/auth', page: () => const AuthView()),
  GetPage(name: '/auth/login', page: () => const AuthLoginView()),
  GetPage(name: '/auth/forgot', page: () => const AuthForgotView()),
  GetPage(name: '/auth/register', page: () => const AuthRegisterView()),
  GetPage(name: '/app', page: () => const AppView()),
  GetPage(
    name: '/app/search/:type',
    page: () => SearchView(
      type: Get.parameters['type'],
    ),
  ),
  GetPage(name: '/app/profile', page: () => const ProfileEditView()),
  GetPage(name: '/app/cropper', page: () => const CropperView()),
  GetPage(name: '/app/blocks', page: () => const BlocksView()),
  GetPage(name: '/app/favorites', page: () => const FavoritesView()),
  GetPage(name: '/app/transactions', page: () => const TransactionsView()),
  GetPage(
    name: '/app/notification',
    page: () => const AccountNotificationView(),
  ),
  GetPage(
    name: '/app/security',
    page: () => const AccountSecurityView(),
  ),
  GetPage(
    name: '/app/account_verify_phone',
    page: () => const AccountVerifyPhoneView(),
  ),
  GetPage(
    name: '/app/account_delete_leave/:type',
    page: () => const AccountDeleteLeaveView(),
  ),
  GetPage(
    name: '/app/purchase/one-step',
    page: () => const PurchaseOneStepView(),
  ),
  GetPage(
    name: '/app/earning',
    page: () => const EarningIncomeView(),
  ),
  GetPage(name: '/profile/:id', page: () => const ProfileView()),
  GetPage(
    name: '/page/plans',
    page: () => const PageView(
      title: 'راهنمای پلن ها',
      page: 'plans',
    ),
  ),
  GetPage(
    name: '/page/terms',
    page: () => const PageView(
      title: 'شرایط استفاده',
      page: 'terms',
    ),
  ),
  GetPage(
    name: '/page/privacy',
    page: () => const PageView(
      title: 'حریم خصوصی',
      page: 'privacy',
    ),
  ),
  GetPage(
    name: '/page/contact',
    page: () => const ContactView(),
  ),
  GetPage(
    name: '/payment',
    page: () => const PaymentView(),
  ),
];
