import 'dart:convert';
import 'dart:io';

import 'package:benmore_challange/controller/auth_controller.dart';
import 'package:benmore_challange/presentation/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../domain/repositories/media_repo.dart';
import '../../widgets/widgets.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  bool _obscure = true;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController confirmPwd = TextEditingController();

  File? _profilePic;
  String? _profilePicBase64Image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: GetBuilder<AuthController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 70),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Register',
                                style: AppTextStyle.subTitle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final image = await MediaService().pickImage();
                              if (image != null) {
                                final File imageFile = File(image.path);
                                String extension =
                                    imageFile.path.split('.').last;
                                final String base64Image =
                                    base64Encode(await imageFile.readAsBytes());
                                setState(() {
                                  _profilePic = imageFile;
                                  _profilePicBase64Image =
                                      'data:image/$extension;base64,$base64Image';
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.ash),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: _profilePic != null
                                    ? FileImage(_profilePic!)
                                    : null,
                                backgroundColor: Colors.white,
                                child: _profilePic == null
                                    ? const Icon(
                                        Ionicons.image_outline,
                                        size: 50,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Select profile picture",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(height: 30),
                        labelText('Email Address'),
                        AppInputField(
                          validator: validateEmail,
                          controller: email,
                          hintText: 'Enter Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        labelText('Username'),
                        AppInputField(
                          validator: validateTextField,
                          controller: username,
                          hintText: 'Enter username',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        labelText('Password'),
                        AppInputField(
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Password is required';
                            } else if (text.length < 6) {
                              return 'Password should be at least 6 characters';
                            }
                            return null;
                          },
                          controller: pwd,
                          hintText: 'Enter Password',
                          obscureText: _obscure,
                          maxLines: 1,
                          suffix: GestureDetector(
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        labelText('Confirm Password'),
                        AppInputField(
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Password is required';
                            } else if (text.length < 6) {
                              return 'Password should be at least 6 characters';
                            } else if (pwd.text != text) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          controller: confirmPwd,
                          hintText: 'Enter Password',
                          obscureText: _obscure,
                          maxLines: 1,
                          suffix: GestureDetector(
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 35),
                        Obx(() {
                          return PrimaryButton(
                            loading: authController.isLoading.value,
                            text: 'Register',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (_profilePicBase64Image == null) {
                                  Get.showSnackbar(
                                    const GetSnackBar(
                                      message: "Profile Picture is required",
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  authController.register(
                                    username: username.text,
                                    email: email.text,
                                    password: pwd.text,
                                    profilePic: _profilePicBase64Image!,
                                  );
                                }
                              }
                            },
                          );
                        }),
                        const SizedBox(height: 35),
                        InkWell(
                          onTap: () async {},
                          child: Container(
                            height: 54,
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.google,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Sign In with Google',
                                  style: AppTextStyle.buttonTitle
                                      .copyWith(color: AppColors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () => Get.to(const LoginScreen()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Alread have an Account? ',
                                style: AppTextStyle.label,
                              ),
                              Text(
                                'Login',
                                style: AppTextStyle.label
                                    .copyWith(color: AppColors.primaryColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
