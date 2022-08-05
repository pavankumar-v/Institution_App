import 'dart:ffi';

class AppConfig {
  final Float version;
  final String description;
  final String note;
  final String androidUrl;
  final String IOSUrl;

  AppConfig({
    required this.version,
    required this.description,
    required this.note,
    required this.androidUrl,
    required this.IOSUrl,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    print(json);
    return AppConfig(
      version: json['version'],
      description: json['description'],
      note: json['note'],
      androidUrl: json['androidLink'],
      IOSUrl: json['iosLink'],
    );
  }
}
