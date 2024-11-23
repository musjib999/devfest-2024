import 'dart:convert';

import 'package:benmore_challange/controller/auth_controller.dart';
import 'package:benmore_challange/controller/post_controller.dart';
import 'package:benmore_challange/domain/models/user.dart';
import 'package:benmore_challange/presentation/presentation.dart';
import 'package:benmore_challange/presentation/widgets/components/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/models/post.dart';
import 'profile_screen.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController commentCtrl = TextEditingController();
  PostController postController = Get.find<PostController>();
  @override
  void initState() {
    super.initState();
    postController.getSinglePost(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Get.to(
                  ProfileScreen(
                    user: User(
                      id: "12345",
                      username: "john_doe",
                      email: 'johndoe@gmail.com',
                      profilePic: "https://example.com/profile.jpg",
                      posts: 5,
                      followers: ["67890", "54321"],
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: MemoryImage(
                        base64Decode(
                          widget.post.assignedTo.profilePic
                              .split('base64,')
                              .last,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.post.assignedTo.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        const Text(
                          '12 Aug, 2024',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.ash),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
                    base64Decode(widget.post.imageUrl.split('base64,').last),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Expanded(
                  child: postController.isLoading.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : postController.comments.isEmpty
                          ? Empty(
                              size: 100,
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                final comment = postController.comments[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: MemoryImage(
                                      base64Decode(
                                        comment.user.profilePic
                                            .split('base64,')
                                            .last,
                                      ),
                                    ),
                                  ),
                                  title: Text(comment.user.username),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comment.comment),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text('Reply'),
                                      )
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite_border,
                                    ),
                                  ),
                                );
                              },
                              itemCount: postController.comments.length,
                            ),
                );
              }),
              const SizedBox(height: 10),
              AppInputField(
                controller: commentCtrl,
                hintText: 'Comment',
                suffix: GestureDetector(
                  onTap: () {
                    postController.commentOnPost(
                      userId: Get.find<AuthController>().user.value!.id,
                      postId: widget.post.id,
                      commentText: commentCtrl.text,
                    );
                  },
                  child: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
