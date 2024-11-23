import 'package:flutter/material.dart';

import '../themes/themes.dart';
import 'buttons.dart';

enum Status { success, error }

extension StatusX on Status {
  bool get isSuccess => this == Status.success;
  bool get isError => this == Status.error;
}

void showSnackbar(BuildContext context, Status status,
    {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width * 0.25
          : double.infinity,
      backgroundColor: status.isSuccess ? AppColors.success : AppColors.error,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    return picked;
  } else {
    return null;
  }
}

Future<TimeOfDay?> selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    return picked;
  } else {
    return null;
  }
}

void showPopUpDialog(BuildContext context, {required Widget child}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: child,
      );
    },
  );
}

void showInformationPopUp(BuildContext context,
    {required String title,
    required String info,
    required void Function()? onYes}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(info),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: onYes,
              child: const Text(
                'Yes',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            )
          ],
        );
      });
}

void showActionDialog(BuildContext context,
    {required String title,
    required String message,
    required IconData icon,
    required void Function()? onContinue,
    Color? color}) {
  final screenSize = MediaQuery.of(context).size;
  showPopUpDialog(
    context,
    child: Container(
      width: screenSize.width < 800 ? null : screenSize.width * 0.37,
      height: screenSize.width < 800
          ? screenSize.height * 0.58
          : screenSize.height * 0.78,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenSize.width < 800
                ? screenSize.width * 0.30
                : screenSize.width * 0.20,
            width: screenSize.width < 800
                ? screenSize.height * 0.30
                : screenSize.height * 0.20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color ?? AppColors.primaryColor,
                width: 5,
              ),
            ),
            child: Icon(
              icon,
              size: screenSize.width < 800
                  ? screenSize.width * 0.16
                  : screenSize.width * 0.06,
              color: color ?? AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyle.title.copyWith(
              color: color ?? AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyle.headline.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            width: screenSize.width < 800
                ? screenSize.width * 0.70
                : screenSize.width * 0.30,
            text: 'Continue',
            onPressed: onContinue,
          ),
        ],
      ),
    ),
  );
}

void showConfirmationDialog({
  required String title,
  required String subtitle,
  required BuildContext context,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: AppColors.error),
        ),
        content: Text(
          subtitle,
          style: AppTextStyle.body,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onCancel,
            child: const Text('No'),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  }
  String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  RegExp regExp = RegExp(pattern);
  if (!regExp.hasMatch(email)) {
    return 'Invalid Email';
  }
  return null;
}

String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'Phone number is required';
  }
  String pattern = r'^\+?\d{1,4}?\d{7,14}$';
  RegExp regExp = RegExp(pattern);
  if (!regExp.hasMatch(phoneNumber)) {
    return 'Invalid phone number';
  }
  return null;
}

String? validateTextField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field is required';
  } else {
    return null;
  }
}

CircularProgressIndicator loader(Color color) {
  return CircularProgressIndicator(
    color: color,
  );
}
