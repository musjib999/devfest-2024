import '../../domain/domain.dart';

class AuthRepo extends AuthAbstract {
  static String authUrl = '';
  static String appUrl = '';

  @override
  Future<AuthResponse> login(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email == "test@example.com" && password == "password123") {
      return AuthResponse(
        user: User(
          id: "12345",
          username: "john_doe",
          email: email,
          profilePic: "https://example.com/profile.jpg",
          posts: 5,
          followers: ["67890", "54321"],
        ),
        token: "mockedAccessToken",
        refreshToken: "mockedRefreshToken",
      );
    } else {
      throw Exception("Invalid email or password");
    }
  }

  @override
  Future<User> register({
    required String username,
    required String email,
    required String password,
    required String profilePic,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: "67890",
      username: username,
      email: email,
      profilePic: profilePic,
      posts: 0,
      followers: [],
    );
  }

  Future<User> updateProfile({
    required String id,
    String? username,
    String? profilePic,
    required String token,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: id,
      username: username ?? "updated_username",
      email: "updated_email@example.com",
      profilePic: profilePic ?? "https://example.com/updated_profile.jpg",
      posts: 5,
      followers: ["67890", "54321"],
    );
  }

  Future<User> getUser({required String token}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: "12345",
      username: "mocked_user",
      email: "mocked_email@example.com",
      profilePic: "https://example.com/profile.jpg",
      posts: 10,
      followers: ["67890", "54321", "11223"],
    );
  }

  Future<String> followUser({
    required String token,
    required String userId,
    required String followeeId,
    required String status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (status == "follow") {
      return "User followed successfully";
    } else if (status == "unfollow") {
      return "User unfollowed successfully";
    } else {
      throw Exception("Invalid follow status");
    }
  }

  @override
  Future changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (oldPassword == "oldPassword123" && newPassword.isNotEmpty) {
      return "Password changed successfully";
    } else {
      throw Exception("Invalid password details");
    }
  }
}
