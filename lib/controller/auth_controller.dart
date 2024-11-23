import 'package:benmore_challange/data/data.dart';
import 'package:benmore_challange/domain/domain.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../presentation/screens/screens.dart';

class AuthController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final Rx<String> token = Rx<String>('');

  RxBool isLoading = false.obs;
  PageController pageController = PageController();

  static AuthController get instance => Get.find();
  final AuthRepo _authService = AuthRepo();

  @override
  void onClose() {
    super.onClose();
    isLoading(false);
    update();
  }

  void login({required String email, required String password}) async {
    isLoading(true);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      token.value = response.token;
      user.value = response.user;
      update();
      Get.off(const HomeScreen());
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  void register({
    required String username,
    required String email,
    required String password,
    required String profilePic,
  }) async {
    try {
      isLoading(true);
      final response = await _authService.register(
        username: username,
        email: email,
        password: password,
        profilePic: profilePic,
      );
      user.value = response;
      Get.showSnackbar(
        const GetSnackBar(
          message: "User Registered Successfully",
          duration: Duration(seconds: 2),
        ),
      );
      Get.off(const LoginScreen());
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  void followOrUnfollow(
      {required String followeeId, required String status}) async {
    isLoading(true);
    try {
      final response = await _authService.followUser(
        token: token.value,
        userId: user.value!.id,
        followeeId: followeeId,
        status: status,
      );
      Get.showSnackbar(
        GetSnackBar(
          message: response,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  void logout() {
    user.value = null;
    update();
  }
}
