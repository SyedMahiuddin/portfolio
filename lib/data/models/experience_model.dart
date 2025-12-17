class ExperienceModel {
  final String id;
  final String company;
  final String position;
  final String description;
  final String startDate;
  final String? endDate;
  final bool isCurrently;

  ExperienceModel({
    required this.id,
    required this.company,
    required this.position,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.isCurrently,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'],
      isCurrently: json['isCurrently'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrently': isCurrently,
    };
  }
}