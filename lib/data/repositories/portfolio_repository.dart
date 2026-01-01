import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/education_model.dart';
import '../models/message_model.dart';
import '../models/profile_model.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get main profile (backwards compatibility)
  Future<ProfileModel?> getProfile() async {
    try {
      final doc = await _firestore.collection('profile').doc('main').get();
      if (doc.exists) {
        return ProfileModel.fromJson({...doc.data()!, 'id': 'main'});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get all team members
  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      final snapshot = await _firestore.collection('profile').get();
      return snapshot.docs
          .map((doc) => ProfileModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error loading profiles: $e');
      return [];
    }
  }

  // Get single profile by ID
  Future<ProfileModel?> getProfileById(String id) async {
    try {
      final doc = await _firestore.collection('profile').doc(id).get();
      if (doc.exists) {
        return ProfileModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  // Add new team member
  Future<String?> addProfile(ProfileModel profile) async {
    try {
      final docRef = await _firestore.collection('profile').add(profile.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding profile: $e');
      return null;
    }
  }

  // Update existing profile
  Future<void> updateProfile(ProfileModel profile) async {
    await _firestore.collection('profile').doc(profile.id).set(profile.toJson());
  }

  // Delete team member
  Future<void> deleteProfile(String id) async {
    await _firestore.collection('profile').doc(id).delete();
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection('messages').add(message.toJson());
  }

  Future<List<MessageModel>> getMessages() async {
    try {
      final snapshot = await _firestore
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => MessageModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> markMessageAsRead(String id) async {
    await _firestore.collection('messages').doc(id).update({'isRead': true});
  }

  Future<void> deleteMessage(String id) async {
    await _firestore.collection('messages').doc(id).delete();
  }

  Future<void> addProject(ProjectModel project) async {
    await _firestore.collection('projects').add(project.toJson());
  }

  Future<void> updateProject(ProjectModel project) async {
    await _firestore.collection('projects').doc(project.id).update(project.toJson());
  }

  Future<void> deleteProject(String id) async {
    await _firestore.collection('projects').doc(id).delete();
  }

  Future<void> addExperience(ExperienceModel experience) async {
    await _firestore.collection('experiences').add(experience.toJson());
  }

  Future<void> updateExperience(ExperienceModel experience) async {
    await _firestore.collection('experiences').doc(experience.id).update(experience.toJson());
  }

  Future<void> deleteExperience(String id) async {
    await _firestore.collection('experiences').doc(id).delete();
  }

  Future<void> addEducation(EducationModel education) async {
    await _firestore.collection('education').add(education.toJson());
  }

  Future<void> updateEducation(EducationModel education) async {
    await _firestore.collection('education').doc(education.id).update(education.toJson());
  }

  Future<void> deleteEducation(String id) async {
    await _firestore.collection('education').doc(id).delete();
  }

  Future<void> updateProjectOrder(List<ProjectModel> projects) async {
    final batch = _firestore.batch();
    for (int i = 0; i < projects.length; i++) {
      final ref = _firestore.collection('projects').doc(projects[i].id);
      batch.update(ref, {'orderIndex': i});
    }
    await batch.commit();
  }

  Future<void> updateExperienceOrder(List<ExperienceModel> experiences) async {
    final batch = _firestore.batch();
    for (int i = 0; i < experiences.length; i++) {
      final ref = _firestore.collection('experiences').doc(experiences[i].id);
      batch.update(ref, {'orderIndex': i});
    }
    await batch.commit();
  }

  Future<void> updateEducationOrder(List<EducationModel> educations) async {
    final batch = _firestore.batch();
    for (int i = 0; i < educations.length; i++) {
      final ref = _firestore.collection('education').doc(educations[i].id);
      batch.update(ref, {'orderIndex': i});
    }
    await batch.commit();
  }

  Future<List<ProjectModel>> getProjects() async {
    try {
      final snapshot = await _firestore.collection('projects').get();

      final projects = snapshot.docs.map((doc) {
        final data = doc.data();

        return ProjectModel.fromJson({
          ...data,
          'id': doc.id,
          'orderIndex': data['orderIndex'] ?? 0,
          'details': data['details'] ?? '',
          'features': data['features'] ?? [],
          'projectType': data['projectType'] ?? 'mobile',
          'playStoreUrl': data['playStoreUrl'],
          'appStoreUrl': data['appStoreUrl'],
          'apkUrl': data['apkUrl'],
        });
      }).toList();

      projects.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      return projects;
    } catch (e) {
      print('Error loading projects: $e');
      return [];
    }
  }

  Future<List<ExperienceModel>> getExperiences() async {
    try {
      final snapshot = await _firestore.collection('experiences').get();

      final experiences = snapshot.docs.map((doc) {
        final data = doc.data();

        return ExperienceModel.fromJson({
          ...data,
          'id': doc.id,
          'orderIndex': data['orderIndex'] ?? 0,
        });
      }).toList();

      experiences.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      return experiences;
    } catch (e) {
      print('Error loading experiences: $e');
      return [];
    }
  }

  Future<List<EducationModel>> getEducations() async {
    try {
      final snapshot = await _firestore.collection('education').get();

      final educations = snapshot.docs.map((doc) {
        final data = doc.data();

        return EducationModel.fromJson({
          ...data,
          'id': doc.id,
          'orderIndex': data['orderIndex'] ?? 0,
        });
      }).toList();

      educations.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      return educations;
    } catch (e) {
      print('Error loading educations: $e');
      return [];
    }
  }
}