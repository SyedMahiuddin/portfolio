class ProfileModel {
  final String name;
  final String role;
  final String bio;
  final String imageUrl;
  final String location;
  final int yearsExperience;
  final int projectsCompleted;
  final String cvUrl;
  final String hireMeUrl;
  final String email;
  final String linkedin;
  final String github;
  final String phone;
  final Map<String, List<String>> technicalSkills;

  ProfileModel({
    required this.name,
    required this.role,
    required this.bio,
    required this.imageUrl,
    required this.location,
    required this.yearsExperience,
    required this.projectsCompleted,
    required this.cvUrl,
    required this.hireMeUrl,
    required this.email,
    required this.linkedin,
    required this.github,
    required this.phone,
    required this.technicalSkills,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> skills = {};
    if (json['technicalSkills'] != null) {
      (json['technicalSkills'] as Map<String, dynamic>).forEach((key, value) {
        skills[key] = List<String>.from(value);
      });
    }

    return ProfileModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      bio: json['bio'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      yearsExperience: json['yearsExperience'] ?? 0,
      projectsCompleted: json['projectsCompleted'] ?? 0,
      cvUrl: json['cvUrl'] ?? '',
      hireMeUrl: json['hireMeUrl'] ?? '',
      email: json['email'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      phone: json['phone'] ?? '',
      technicalSkills: skills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'bio': bio,
      'imageUrl': imageUrl,
      'location': location,
      'yearsExperience': yearsExperience,
      'projectsCompleted': projectsCompleted,
      'cvUrl': cvUrl,
      'hireMeUrl': hireMeUrl,
      'email': email,
      'linkedin': linkedin,
      'github': github,
      'phone': phone,
      'technicalSkills': technicalSkills,
    };
  }
}