import 'package:benmore_challange/domain/models/user.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  int likes;
  final List<String> likedBy;
  final Profile assignedTo;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.likedBy,
    required this.assignedTo,
  });
  bool isLikedByUser(String userId) {
    return likedBy.contains(userId);
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      likes: json['likes'],
      likedBy: List<String>.from(json["likedBy"].map((x) => x)),
      assignedTo: Profile.fromJson(json['assigned_to']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
      'assigned_to': assignedTo.toJson(),
    };
  }
}

class Profile {
  final String id;
  final String username;
  final String profilePic;

  Profile({
    required this.id,
    required this.username,
    required this.profilePic,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'],
      username: json['username'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'profilePic': profilePic,
    };
  }
}

class Comment {
  final Profile user;
  final String comment;
  final DateTime timestamp;

  Comment({
    required this.user,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: Profile.fromJson(json['user']),
      comment: json['comment'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class PostModel {
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final List<Comment> comments;
  final int likes;
  final String status;
  final Profile assignedTo;

  PostModel({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    required this.comments,
    required this.likes,
    required this.status,
    required this.assignedTo,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      likes: json['likes'],
      status: json['status'],
      assignedTo: Profile.fromJson(json['assigned_to']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'likes': likes,
      'status': status,
      'assigned_to': assignedTo.toJson(),
    };
  }
}
