import 'package:cloud_firestore/cloud_firestore.dart';

class DataMigration {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> migrateExistingData() async {
    print('🔄 Starting data migration...');

    await _migrateProjects();
    await _migrateExperiences();
    await _migrateEducations();

    print('✅ Data migration completed');
  }

  static Future<void> _migrateProjects() async {
    try {
      print('📦 Migrating projects...');
      final snapshot = await _firestore.collection('projects').get();

      if (snapshot.docs.isEmpty) {
        print('ℹ️ No projects to migrate');
        return;
      }

      int index = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (!data.containsKey('orderIndex')) {
          await doc.reference.update({
            'orderIndex': index,
          });
          print('✓ Migrated project: ${data['title']} (orderIndex: $index)');
          index++;
        }
      }

      print('✅ Projects migration completed');
    } catch (e) {
      print('❌ Error migrating projects: $e');
    }
  }

  static Future<void> _migrateExperiences() async {
    try {
      print('💼 Migrating experiences...');
      final snapshot = await _firestore.collection('experiences').get();

      if (snapshot.docs.isEmpty) {
        print('ℹ️ No experiences to migrate');
        return;
      }

      int index = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (!data.containsKey('orderIndex')) {
          await doc.reference.update({
            'orderIndex': index,
          });
          print('✓ Migrated experience: ${data['position']} at ${data['company']} (orderIndex: $index)');
          index++;
        }
      }

      print('✅ Experiences migration completed');
    } catch (e) {
      print('❌ Error migrating experiences: $e');
    }
  }

  static Future<void> _migrateEducations() async {
    try {
      print('🎓 Migrating educations...');
      final snapshot = await _firestore.collection('education').get();

      if (snapshot.docs.isEmpty) {
        print('ℹ️ No educations to migrate');
        return;
      }

      int index = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (!data.containsKey('orderIndex')) {
          await doc.reference.update({
            'orderIndex': index,
          });
          print('✓ Migrated education: ${data['degree']} (orderIndex: $index)');
          index++;
        }
      }

      print('✅ Educations migration completed');
    } catch (e) {
      print('❌ Error migrating educations: $e');
    }
  }

  static Future<void> addMissingFieldsToProjects() async {
    try {
      print('🔧 Checking for missing fields in projects...');
      final snapshot = await _firestore.collection('projects').get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        Map<String, dynamic> updates = {};

        if (!data.containsKey('details')) {
          updates['details'] = '';
        }
        if (!data.containsKey('features')) {
          updates['features'] = [];
        }
        if (!data.containsKey('projectType')) {
          updates['projectType'] = 'mobile';
        }
        if (!data.containsKey('playStoreUrl')) {
          updates['playStoreUrl'] = null;
        }
        if (!data.containsKey('appStoreUrl')) {
          updates['appStoreUrl'] = null;
        }
        if (!data.containsKey('apkUrl')) {
          updates['apkUrl'] = null;
        }

        if (updates.isNotEmpty) {
          await doc.reference.update(updates);
          print('✓ Added missing fields to project: ${data['title']}');
        }
      }

      print('✅ Missing fields check completed for projects');
    } catch (e) {
      print('❌ Error adding missing fields: $e');
    }
  }
}