class Report {
  String name;
  String uid;
  String title;
  String description;
  String createdAt;
  List<dynamic> attactments;
  bool isStarted;
  bool isResolved;
  String remarks;

  Report({
    required this.name,
    required this.uid,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.attactments,
    required this.isStarted,
    required this.isResolved,
    required this.remarks,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      name: json['name'],
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      attactments: json['attactments'],
      isStarted: json['isStarted'],
      isResolved: json['isResolved'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'attactments': attactments,
      'isStarted': isStarted,
      'isResolved': isResolved,
      'remarks': remarks,
    };
  }
}
