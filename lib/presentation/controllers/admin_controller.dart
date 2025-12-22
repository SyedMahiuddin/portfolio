import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/message_model.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/project_model.dart';
import '../../data/models/experience_model.dart';
import '../../data/repositories/portfolio_repository.dart';

class AdminController extends GetxController {
  final PortfolioRepository _repository = PortfolioRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<ExperienceModel> experiences = <ExperienceModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTab = 0.obs;

  // Profile Controllers
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final bioController = TextEditingController();
  final locationController = TextEditingController();
  final yearsExpController = TextEditingController();
  final projectsCompletedController = TextEditingController();
  final cvUrlController = TextEditingController();
  final imageUrlController = TextEditingController();
  final hireMeUrlController = TextEditingController();
  final emailController = TextEditingController();
  final linkedinController = TextEditingController();
  final githubController = TextEditingController();
  final phoneController = TextEditingController(); // Added phone controller

  // Skills Controllers
  final RxMap<String, List<String>> technicalSkills = <String, List<String>>{}.obs;
  final skillCategoryController = TextEditingController();
  final skillItemController = TextEditingController();
  final RxString selectedSkillCategory = ''.obs;

  // Project Controllers
  final projectTitleController = TextEditingController();
  final projectDescController = TextEditingController();
  final projectDetailsController = TextEditingController();
  final projectLiveUrlController = TextEditingController();
  final projectGithubUrlController = TextEditingController();
  final projectPlayStoreController = TextEditingController();
  final projectAppStoreController = TextEditingController();
  final projectApkUrlController = TextEditingController();
  final projectImageUrlController = TextEditingController();
  final RxString selectedProjectType = 'mobile'.obs;
  final RxList<String> projectImages = <String>[].obs;
  final RxList<String> projectTechs = <String>[].obs;
  final RxList<String> projectFeatures = <String>[].obs;
  final techInputController = TextEditingController();
  final featureInputController = TextEditingController();

  // Experience Controllers
  final expCompanyController = TextEditingController();
  final expPositionController = TextEditingController();
  final expDescController = TextEditingController();
  final expStartDateController = TextEditingController();
  final expEndDateController = TextEditingController();
  final RxBool expIsCurrently = false.obs;

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    await Future.wait([
      loadProfile(),
      loadProjects(),
      loadExperiences(),
      loadMessages(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadProfile() async {
    final data = await _repository.getProfile();
    if (data != null) {
      profile.value = data;
      nameController.text = data.name;
      roleController.text = data.role;
      bioController.text = data.bio;
      locationController.text = data.location;
      yearsExpController.text = data.yearsExperience.toString();
      projectsCompletedController.text = data.projectsCompleted.toString();
      cvUrlController.text = data.cvUrl;
      imageUrlController.text = data.imageUrl;
      hireMeUrlController.text = data.hireMeUrl;
      emailController.text = data.email;
      linkedinController.text = data.linkedin;
      githubController.text = data.github;
      phoneController.text = data.phone;
      technicalSkills.value = data.technicalSkills;
    }
  }

  Future<void> loadProjects() async {
    final data = await _repository.getProjects();
    projects.value = data;
  }

  Future<void> loadExperiences() async {
    final data = await _repository.getExperiences();
    experiences.value = data;
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final updatedProfile = ProfileModel(
        name: nameController.text,
        role: roleController.text,
        bio: bioController.text,
        imageUrl: imageUrlController.text,
        location: locationController.text,
        yearsExperience: int.tryParse(yearsExpController.text) ?? 0,
        projectsCompleted: int.tryParse(projectsCompletedController.text) ?? 0,
        cvUrl: cvUrlController.text,
        hireMeUrl: hireMeUrlController.text,
        email: emailController.text,
        linkedin: linkedinController.text,
        github: githubController.text,
        phone: phoneController.text,
        technicalSkills: technicalSkills,
      );
      await _repository.updateProfile(updatedProfile);
      profile.value = updatedProfile;
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Skills Management Methods
  void addSkillCategory() {
    if (skillCategoryController.text.isNotEmpty) {
      technicalSkills[skillCategoryController.text] = [];
      skillCategoryController.clear();
      technicalSkills.refresh();
    }
  }

  void addSkillToCategory(String category) {
    if (skillItemController.text.isNotEmpty) {
      if (technicalSkills.containsKey(category)) {
        technicalSkills[category]!.add(skillItemController.text);
        technicalSkills.refresh();
        skillItemController.clear();
      }
    }
  }

  void removeSkillCategory(String category) {
    technicalSkills.remove(category);
    technicalSkills.refresh();
  }

  void removeSkillFromCategory(String category, int index) {
    if (technicalSkills.containsKey(category)) {
      technicalSkills[category]!.removeAt(index);
      technicalSkills.refresh();
    }
  }

  void selectSkillCategory(String category) {
    selectedSkillCategory.value = category;
  }

  // Project Methods
  Future<void> addProject() async {
    try {
      isLoading.value = true;
      final newProject = ProjectModel(
        id: '',
        title: projectTitleController.text,
        description: projectDescController.text,
        details: projectDetailsController.text,
        features: projectFeatures.toList(),
        images: projectImages.toList(),
        technologies: projectTechs.toList(),
        projectType: selectedProjectType.value,
        liveUrl: projectLiveUrlController.text.isEmpty ? null : projectLiveUrlController.text,
        githubUrl: projectGithubUrlController.text.isEmpty ? null : projectGithubUrlController.text,
        playStoreUrl: projectPlayStoreController.text.isEmpty ? null : projectPlayStoreController.text,
        appStoreUrl: projectAppStoreController.text.isEmpty ? null : projectAppStoreController.text,
        apkUrl: projectApkUrlController.text.isEmpty ? null : projectApkUrlController.text,
        createdAt: DateTime.now(),
      );
      await _repository.addProject(newProject);
      await loadProjects();
      clearProjectForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Project added successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add project: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      final updatedProject = ProjectModel(
        id: project.id,
        title: projectTitleController.text,
        description: projectDescController.text,
        details: projectDetailsController.text,
        features: projectFeatures.toList(),
        images: projectImages.toList(),
        technologies: projectTechs.toList(),
        projectType: selectedProjectType.value,
        liveUrl: projectLiveUrlController.text.isEmpty ? null : projectLiveUrlController.text,
        githubUrl: projectGithubUrlController.text.isEmpty ? null : projectGithubUrlController.text,
        playStoreUrl: projectPlayStoreController.text.isEmpty ? null : projectPlayStoreController.text,
        appStoreUrl: projectAppStoreController.text.isEmpty ? null : projectAppStoreController.text,
        apkUrl: projectApkUrlController.text.isEmpty ? null : projectApkUrlController.text,
        createdAt: project.createdAt,
      );
      await _repository.updateProject(updatedProject);
      await loadProjects();
      clearProjectForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Project updated successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update project: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      isLoading.value = true;
      await _repository.deleteProject(id);
      await loadProjects();
      Get.snackbar(
        'Success',
        'Project deleted successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete project: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Experience Methods
  Future<void> addExperience() async {
    try {
      isLoading.value = true;
      final newExp = ExperienceModel(
        id: '',
        company: expCompanyController.text,
        position: expPositionController.text,
        description: expDescController.text,
        startDate: expStartDateController.text,
        endDate: expIsCurrently.value ? null : expEndDateController.text,
        isCurrently: expIsCurrently.value,
      );
      await _repository.addExperience(newExp);
      await loadExperiences();
      clearExperienceForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Experience added successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add experience: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateExperience(ExperienceModel exp) async {
    try {
      isLoading.value = true;
      final updatedExp = ExperienceModel(
        id: exp.id,
        company: expCompanyController.text,
        position: expPositionController.text,
        description: expDescController.text,
        startDate: expStartDateController.text,
        endDate: expIsCurrently.value ? null : expEndDateController.text,
        isCurrently: expIsCurrently.value,
      );
      await _repository.updateExperience(updatedExp);
      await loadExperiences();
      clearExperienceForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Experience updated successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update experience: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExperience(String id) async {
    try {
      isLoading.value = true;
      await _repository.deleteExperience(id);
      await loadExperiences();
      Get.snackbar(
        'Success',
        'Experience deleted successfully',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete experience: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Project Helper Methods
  void addProjectImageUrl() {
    if (projectImageUrlController.text.isNotEmpty) {
      projectImages.add(projectImageUrlController.text);
      projectImageUrlController.clear();
    }
  }

  void addTechnology() {
    if (techInputController.text.isNotEmpty) {
      projectTechs.add(techInputController.text);
      techInputController.clear();
    }
  }

  void addFeature() {
    if (featureInputController.text.isNotEmpty) {
      projectFeatures.add(featureInputController.text);
      featureInputController.clear();
    }
  }

  void removeTechnology(int index) {
    projectTechs.removeAt(index);
  }

  void removeFeature(int index) {
    projectFeatures.removeAt(index);
  }

  void removeProjectImage(int index) {
    projectImages.removeAt(index);
  }

  void editProject(ProjectModel project) {
    projectTitleController.text = project.title;
    projectDescController.text = project.description;
    projectDetailsController.text = project.details;
    projectLiveUrlController.text = project.liveUrl ?? '';
    projectGithubUrlController.text = project.githubUrl ?? '';
    projectPlayStoreController.text = project.playStoreUrl ?? '';
    projectAppStoreController.text = project.appStoreUrl ?? '';
    projectApkUrlController.text = project.apkUrl ?? '';
    selectedProjectType.value = project.projectType;
    projectImages.value = project.images;
    projectTechs.value = project.technologies;
    projectFeatures.value = project.features;
  }

  void editExperience(ExperienceModel exp) {
    expCompanyController.text = exp.company;
    expPositionController.text = exp.position;
    expDescController.text = exp.description;
    expStartDateController.text = exp.startDate;
    expEndDateController.text = exp.endDate ?? '';
    expIsCurrently.value = exp.isCurrently;
  }

  Future<void> loadMessages() async {
    final data = await _repository.getMessages();
    messages.value = data;
    unreadCount.value = data.where((m) => !m.isRead).length;
  }

  Future<void> markAsRead(String id) async {
    await _repository.markMessageAsRead(id);
    await loadMessages();
  }

  Future<void> deleteMessage(String id) async {
    await _repository.deleteMessage(id);
    await loadMessages();
  }

  void clearProjectForm() {
    projectTitleController.clear();
    projectDescController.clear();
    projectDetailsController.clear();
    projectLiveUrlController.clear();
    projectGithubUrlController.clear();
    projectPlayStoreController.clear();
    projectAppStoreController.clear();
    projectApkUrlController.clear();
    projectImageUrlController.clear();
    selectedProjectType.value = 'mobile';
    projectImages.clear();
    projectTechs.clear();
    projectFeatures.clear();
    techInputController.clear();
    featureInputController.clear();
  }

  void clearExperienceForm() {
    expCompanyController.clear();
    expPositionController.clear();
    expDescController.clear();
    expStartDateController.clear();
    expEndDateController.clear();
    expIsCurrently.value = false;
  }

  void clearSkillsForm() {
    skillCategoryController.clear();
    skillItemController.clear();
    selectedSkillCategory.value = '';
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/');
  }

  @override
  void onClose() {
    nameController.dispose();
    roleController.dispose();
    bioController.dispose();
    locationController.dispose();
    yearsExpController.dispose();
    projectsCompletedController.dispose();
    cvUrlController.dispose();
    imageUrlController.dispose();
    hireMeUrlController.dispose();
    emailController.dispose();
    linkedinController.dispose();
    githubController.dispose();
    phoneController.dispose();
    skillCategoryController.dispose();
    skillItemController.dispose();
    projectTitleController.dispose();
    projectDescController.dispose();
    projectDetailsController.dispose();
    projectLiveUrlController.dispose();
    projectGithubUrlController.dispose();
    projectPlayStoreController.dispose();
    projectAppStoreController.dispose();
    projectApkUrlController.dispose();
    projectImageUrlController.dispose();
    techInputController.dispose();
    featureInputController.dispose();
    expCompanyController.dispose();
    expPositionController.dispose();
    expDescController.dispose();
    expStartDateController.dispose();
    expEndDateController.dispose();
    super.onClose();
  }
}