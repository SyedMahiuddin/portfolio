import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile_model.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileModel?> getProfile() async {
    try {
      final doc = await _firestore.collection('profile').doc('main').get();
      if (doc.exists) {
        return ProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ProjectModel>> getProjects() async {
    try {
      final snapshot = await _firestore
          .collection('projects')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ProjectModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ExperienceModel>> getExperiences() async {
    try {
      final snapshot = await _firestore
          .collection('experiences')
          .orderBy('startDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ExperienceModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _firestore.collection('profile').doc('main').set(profile.toJson());
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
}