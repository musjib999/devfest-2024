import 'package:benmore_challange/presentation/screens/auth/registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../presentation.dart';

class LoginScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const LoginScreen());
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  bool _obscure = true;
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();

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
                                'Login',
                                style: AppTextStyle.subTitle,
                                textAlign: TextAlign.center,
                              ),
                            ],
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
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        TextButton(
                          // onPressed: () => Navigator.of(context)
                          //     .push(ForgotPasswordScreen.route()),
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyle.body.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        Obx(() {
                          return PrimaryButton(
                            loading: authController.isLoading.value,
                            text: 'Login',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                authController.login(
                                  email: email.text,
                                  password: pwd.text,
                                );
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
                          onTap: () => Get.to(const UserRegistrationScreen()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an Account? ',
                                style: AppTextStyle.label,
                              ),
                              Text(
                                'Register',
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
