abstract class AuthAbstract {
  Future login({required String email, required String password});

  Future register({
    required String username,
    required String email,
    required String password,
    required String profilePic,
  });

  Future changePassword(
      {required String oldPassword, required String newPassword});
}
