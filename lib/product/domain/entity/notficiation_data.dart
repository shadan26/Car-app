class NotificationData {
  final String ?title;
  final String ?body;
  final String ?userEmail;
  final String? userId;
  final String? imageURL;
  int ?createdAt;
  bool ?isOpened;
  bool ?isViewed;

  NotificationData({
    this.title,
    this.body,
    this.userEmail,
    this.userId,
    this.createdAt,
    this.imageURL,
    this.isOpened ,
    this.isViewed ,
  });
}