class UserData {
  final String ?id;
  final String ?email;
  final int ?createdAt;
  final String? role;
  final String? token;

  UserData({
    this.id,
    this.email,
    this.role,
    this.createdAt,
    this.token
  });
}