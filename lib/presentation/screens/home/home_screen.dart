import 'package:benmore_challange/controller/auth_controller.dart';
import 'package:benmore_challange/controller/post_controller.dart';
import 'package:benmore_challange/data/data.dart';
import 'package:benmore_challange/presentation/screens/home/add_post.dart';
import 'package:benmore_challange/presentation/screens/home/post_screen.dart';
import 'package:benmore_challange/presentation/screens/home/widget/post_item.dart';
import 'package:benmore_challange/presentation/widgets/components/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final postController = Get.put(PostController());
  final currentUserId = AuthController.instance.user.value!.id;

  String image =
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          margin: const EdgeInsets.all(15),
          child: postController.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : postController.posts.isEmpty
                  ? const Center(
                      child: Empty(),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final post = postController.posts[index];
                        final isLiked = post.isLikedByUser(currentUserId);
                        return InkWell(
                          onTap: () => Get.to(
                            PostScreen(post: post),
                          ),
                          child: PostItem(
                            profileImageUrl: post.assignedTo.profilePic
                                .split('base64,')
                                .last,
                            username: post.assignedTo.username,
                            date: '12 Feb, 2024',
                            postImageUrl: post.imageUrl.split('base64,').last,
                            description: post.title,
                            likes: post.likes,
                            isLiked: isLiked,
                            onLike: (isNowLiked) async {
                              setState(() {
                                if (isNowLiked) {
                                  PostRepo().likePost(
                                    accessToken:
                                        AuthController.instance.token.value,
                                    userId: currentUserId,
                                    postId: post.id,
                                  );
                                  post.likedBy.add(currentUserId);
                                } else {
                                  post.likedBy.remove(currentUserId);
                                }
                              });
                            },
                          ),
                        );
                      },
                      itemCount: postController.posts.length,
                    ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(const AddPost()),
        label: const Text('Post'),
      ),
    );
  }
}
