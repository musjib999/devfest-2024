import 'dart:convert';
import 'dart:io';

import 'package:benmore_challange/controller/auth_controller.dart';
import 'package:benmore_challange/controller/post_controller.dart';
import 'package:benmore_challange/domain/repositories/media_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../../widgets/widgets.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _formKey = GlobalKey<FormState>();
  final postController = Get.find<PostController>();
  final title = TextEditingController();
  final description = TextEditingController();
  final auth = AuthController.instance;
  File? _pic;
  String? _picBase64Image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText('Title'),
                  AppInputField(
                    validator: validateTextField,
                    controller: title,
                    hintText: 'Enter title',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  labelText('Description'),
                  AppInputField(
                    validator: validateTextField,
                    controller: description,
                    hintText: 'Enter description',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final image = await MediaService()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          final File imageFile = File(image.path);
                          String extension = imageFile.path.split('.').last;
                          final String base64Image =
                              base64Encode(await imageFile.readAsBytes());
                          setState(() {
                            _pic = imageFile;
                            _picBase64Image =
                                'data:image/$extension;base64,$base64Image';
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.ash),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          child: _pic != null
                              ? Image.file(
                                  _pic!,
                                  fit: BoxFit.fill,
                                )
                              : const Icon(
                                  Ionicons.image_outline,
                                  size: 50,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return PrimaryButton(
                      text: 'Post',
                      loading: postController.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_pic == null) {
                            Get.showSnackbar(
                              const GetSnackBar(
                                message: 'Please select an image',
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            postController.addPosts(
                              title: title.text,
                              description: description.text,
                              image: _picBase64Image!,
                              userId: auth.user.value!.id,
                            );
                          }
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
