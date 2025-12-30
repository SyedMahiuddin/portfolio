import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class InitialDataSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> setupFromBackupAsset() async {
    try {
      // 1️⃣ Load text file from assets
      final String rawText = await rootBundle.loadString(
        'assets/backup_data_1767131609002.txt',
      );

      // 2️⃣ Decode JSON
      final Map<String, dynamic> data = jsonDecode(rawText);

      // 3️⃣ Upload profile
      await _firestore
          .collection('profile')
          .doc('main')
          .set(data['profile']);

      // 4️⃣ Upload projects
      for (final project in data['projects']) {
        await _firestore.collection('projects').add(project);
      }

      // 5️⃣ Upload experiences
      for (final experience in data['experiences']) {
        await _firestore.collection('experiences').add(experience);
      }

      // 6️⃣ Upload educations (if exists)
      if (data.containsKey('educations')) {
        for (final education in data['educations']) {
          await _firestore.collection('educations').add(education);
        }
      }

      print('✅ Firestore restored from backup file');
    } catch (e) {
      print('❌ Restore failed: $e');
    }
  }
}
