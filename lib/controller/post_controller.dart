import 'package:benmore_challange/controller/auth_controller.dart';
import 'package:benmore_challange/domain/domain.dart';
import 'package:benmore_challange/domain/models/post.dart';
import 'package:get/get.dart';

import '../data/data.dart';

class PostController extends GetxController {
  final PostRepo _postRepo = PostRepo();

  RxBool isLoading = false.obs;
  var posts = <Post>[].obs;
  var userPosts = <Post>[].obs;
  PostModel? post;
  var comments = <Comment>[].obs;
  final _auth = Get.find<AuthController>();

  @override
  void onInit() {
    getPosts();
    super.onInit();
  }

  void getPosts() async {
    isLoading(true);
    try {
      final allPosts =
          await _postRepo.getAllPosts(accessToken: _auth.token.value);
      if (allPosts.isEmpty) {
        posts.value = [];
      } else {
        posts.value = allPosts;
      }
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

  void addPosts(
      {required String title,
      required String description,
      required String image,
      required String userId}) async {
    isLoading(true);
    try {
      final post = await _postRepo.addPost(
        accessToken: _auth.token.value,
        title: title,
        description: description,
        userId: userId,
        image: image,
      );
      posts.add(post!);
      Get.back();
      update();
    } catch (e, s) {
      print(s);
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

  void getSinglePost(String id) async {
    try {
      final singlePost =
          await _postRepo.getOnePost(accessToken: _auth.token.value, id: id);
      post = singlePost;
      comments.value = singlePost.comments;
      update();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      update();
    }
  }

  void getUserPosts(String userId) async {
    isLoading(true);
    try {
      final allPosts = await _postRepo.getUserPost(
        userId: userId,
        accessToken: _auth.token.value,
      );
      if (allPosts.isEmpty) {
        userPosts.value = [];
      } else {
        userPosts.value = allPosts;
      }
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

  void commentOnPost(
      {required String userId,
      required String postId,
      required String commentText}) async {
    isLoading(true);
    try {
      final comment = await _postRepo.comment(
        userId: userId,
        postId: postId,
        comment: commentText,
        accessToken: _auth.token.value,
      );
      if (comment != null) {
        comments.add(
          Comment(
            user: Profile(
              id: _auth.user.value!.id,
              username: _auth.user.value!.username,
              profilePic: _auth.user.value!.profilePic,
            ),
            comment: comment,
            timestamp: DateTime.now(),
          ),
        );
        update();
      }
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
}
