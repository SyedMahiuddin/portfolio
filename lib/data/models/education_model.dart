class EducationModel {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final String description;
  final String startDate;
  final String? endDate;
  final bool isCurrently;
  final int orderIndex;

  EducationModel({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.isCurrently,
    required this.orderIndex,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] ?? '',
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      field: json['field'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'],
      isCurrently: json['isCurrently'] ?? false,
      orderIndex: json['orderIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'field': field,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrently': isCurrently,
      'orderIndex': orderIndex,
    };
  }

  EducationModel copyWith({int? orderIndex}) {
    return EducationModel(
      id: id,
      institution: institution,
      degree: degree,
      field: field,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isCurrently: isCurrently,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}