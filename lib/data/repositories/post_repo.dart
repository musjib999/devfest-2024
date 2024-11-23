import 'package:benmore_challange/data/source/remote/remote_data.dart';
import 'package:benmore_challange/domain/domain.dart';

class PostRepo {
  final List<Post> _mockPosts = [
    Post(
      id: '1',
      title: 'Mock Title 1',
      description: 'Mock Description 1',
      imageUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 10,
      likedBy: ['user1', 'user2'],
      assignedTo: Profile(
        id: 'user1',
        username: 'Mock User',
        profilePic: 'https://via.placeholder.com/100',
      ),
    ),
    Post(
      id: '2',
      title: 'Mock Title 2',
      description: 'Mock Description 2',
      imageUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now(),
      likes: 5,
      likedBy: ['user3'],
      assignedTo: Profile(
        id: 'user2',
        username: 'Mock User 2',
        profilePic: 'https://via.placeholder.com/100',
      ),
    ),
  ];
  final RemoteData _data = RemoteData();
  Future<List<Post>> getAllPosts({required String accessToken}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockPosts;
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel> getOnePost(
      {required String id, required String accessToken}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final post = _mockPosts.firstWhere((post) => post.id == id,
          orElse: () => throw Exception('Post not found'));
      return PostModel(
        title: post.title,
        description: post.description,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        comments: [],
        likes: post.likes,
        status: 'active',
        assignedTo: Profile(
          id: post.assignedTo.id,
          username: post.assignedTo.username,
          profilePic: post.assignedTo.profilePic,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Post?> addPost(
      {required String title,
      required String description,
      required String image,
      required String userId,
      required String accessToken}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        imageUrl: image,
        createdAt: DateTime.now(),
        likes: 0,
        likedBy: [],
        assignedTo: Profile(
          id: userId,
          username: 'Mock User',
          profilePic: 'https://via.placeholder.com/100',
        ),
      );
      _mockPosts.add(newPost);
      return newPost;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getUserPost(
      {required String userId, required String accessToken}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockPosts.where((post) => post.assignedTo.id == userId).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> likePost(
      {required String postId,
      required String userId,
      required String accessToken}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final post = _mockPosts.firstWhere((post) => post.id == postId,
          orElse: () => throw Exception('Post not found'));
      if (!post.likedBy.contains(userId)) {
        post.likedBy.add(userId);
        post.likes++;
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> comment(
      {required String postId,
      required String userId,
      required String comment,
      required String accessToken}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return comment;
    } catch (e) {
      rethrow;
    }
  }
}
