import 'dart:convert';

import 'package:benmore_challange/controller/auth_controller.dart';
import 'package:benmore_challange/controller/post_controller.dart';
import 'package:benmore_challange/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userFollowValue = 'follow';
  @override
  void initState() {
    super.initState();
    bool hasFollowedUser = widget.user.isFollowed(
      AuthController.instance.user.value!.id,
    );
    if (hasFollowedUser) {
      setState(() {
        userFollowValue = 'unfollow';
      });
    } else {
      setState(() {
        userFollowValue = 'follow';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postController = Get.find<PostController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postController.getUserPosts(widget.user.id);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: MemoryImage(
                  base64Decode(widget.user.profilePic.split('base64,').last),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.verified,
                    color: Colors.orange,
                    size: 20,
                  ),
                ],
              ),
              Text(
                widget.user.email,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      AuthController.instance.followOrUnfollow(
                        followeeId: widget.user.id,
                        status: userFollowValue,
                      );
                    },
                    icon: const Icon(
                      Icons.person_add,
                      color: AppColors.white,
                    ),
                    label: Text(
                      userFollowValue,
                      style: const TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                      widget.user.followers.length.toString(), 'Followers'),
                  _buildStatItem('0', 'Likes'),
                  _buildStatItem(widget.user.posts.toString(), 'Posts'),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children:
                      List.generate(postController.userPosts.length, (index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.ash),
                        ),
                        child: Image.memory(
                          base64Decode(
                            postController.userPosts[index].imageUrl
                                .split('base64,')
                                .last,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
