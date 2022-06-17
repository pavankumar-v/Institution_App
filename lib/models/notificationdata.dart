class NotificationData {
  final String fullName;
  final String position;
  final String title;
  final String description;
  final String createdAt;
  final String avatar;

  NotificationData(
      {required this.fullName,
      required this.position,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.avatar});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
        fullName: json['fullName'],
        position: json['position'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'],
        avatar: json['avatar']);
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'position': position,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
