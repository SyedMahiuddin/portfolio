import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/education_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/project_model.dart';
import '../../data/models/experience_model.dart';
import '../../data/repositories/portfolio_repository.dart';
import 'dart:html' as html;

class HomeController extends GetxController {
  final PortfolioRepository _repository = PortfolioRepository();

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<ExperienceModel> experiences = <ExperienceModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSendingMessage = false.obs;
  final RxList<EducationModel> educations = <EducationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> sendMessage({
    required String name,
    required String company,
    required String email,
    required String phone,
    required String message,
  }) async {
    try {
      isSendingMessage.value = true;
      final newMessage = MessageModel(
        id: '',
        name: name,
        company: company,
        email: email,
        phone: phone,
        message: message,
        createdAt: DateTime.now(),
        isRead: false,
      );
      await _repository.sendMessage(newMessage);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> loadEducations() async {
    final data = await _repository.getEducations();
    educations.value = data;
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await Future.wait([
      loadProfile(),
      loadProjects(),
      loadExperiences(),
      loadEducations(),
    ]);

   // await exportAllDataToDownloadWeb();
    isLoading.value = false;
  }

  Future<void> exportAllDataToDownloadWeb() async {
    // 1️⃣ Combine data
    final Map<String, dynamic> data = {
      "profile": profile.toJson(),
      "projects": projects.map((e) => e.toJson()).toList(),
      "experiences": experiences.map((e) => e.toJson()).toList(),
      "educations": educations.map((e) => e.toJson()).toList(),
      "exportedAt": DateTime.now().toIso8601String(),
    };

    // 2️⃣ Convert to text (JSON)
    final String textData =
    const JsonEncoder.withIndent('  ').convert(data);

    // 3️⃣ Create downloadable file
    final bytes = utf8.encode(textData);
    final blob = html.Blob([bytes], 'text/plain');

    final url = html.Url.createObjectUrlFromBlob(blob);

    // 4️⃣ Trigger browser download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
        "download",
        "backup_data_${DateTime.now().millisecondsSinceEpoch}.txt",
      )
      ..click();

    // 5️⃣ Cleanup
    html.Url.revokeObjectUrl(url);
  }

  Future<void> loadProfile() async {
    final data = await _repository.getProfile();
    profile.value = data;
  }

  Future<void> loadProjects() async {
    final data = await _repository.getProjects();
    projects.value = data;
  }

  Future<void> loadExperiences() async {
    final data = await _repository.getExperiences();
    experiences.value = data;
  }
}