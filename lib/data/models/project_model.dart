class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String details;
  final List<String> features;
  final List<String> images;
  final List<String> technologies;
  final String projectType;
  final String? liveUrl;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? apkUrl;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.details,
    required this.features,
    required this.images,
    required this.technologies,
    required this.projectType,
    this.liveUrl,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.apkUrl,
    required this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      details: json['details'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      technologies: List<String>.from(json['technologies'] ?? []),
      projectType: json['projectType'] ?? 'mobile',
      liveUrl: json['liveUrl'],
      githubUrl: json['githubUrl'],
      playStoreUrl: json['playStoreUrl'],
      appStoreUrl: json['appStoreUrl'],
      apkUrl: json['apkUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'details': details,
      'features': features,
      'images': images,
      'technologies': technologies,
      'projectType': projectType,
      'liveUrl': liveUrl,
      'githubUrl': githubUrl,
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
      'apkUrl': apkUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}