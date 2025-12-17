import 'package:cloud_firestore/cloud_firestore.dart';

class InitialDataSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> setupInitialData() async {
    try {
      final profileDoc = await _firestore.collection('profile').doc('main').get();

      if (!profileDoc.exists) {
        await _createInitialProfile();
        await _createSampleProjects();
        await _createSampleExperiences();
        print('✅ Initial data setup completed');
      } else {
        print('ℹ️ Data already exists, skipping initial setup');
      }
    } catch (e) {
      print('❌ Error setting up initial data: $e');
    }
  }

  static Future<void> _createInitialProfile() async {
    await _firestore.collection('profile').doc('main').set({
      'name': 'Syed Mahiuddin',
      'role': 'Mobile App Developer (Flutter)',
      'bio': 'Mobile App Developer with nearly 3 years of professional experience in building scalable Android, iOS, and Web applications. Strong expertise in tracking systems, background location services, ride-sharing platforms, attendance systems, exam applications, and booking solutions.',
      'imageUrl': '',
      'location': 'Dhaka, Bangladesh',
      'yearsExperience': 3,
      'projectsCompleted': 20,
      'cvUrl': '',
      'hireMeUrl': '',
      'email': 'syedmahiuddin01@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/syed-mahiuddin/',
      'github': 'https://github.com/SyedMahiuddin',
      'phone': '+8801783080181',
      'technicalSkills': {
        'Mobile Development': [
          'Flutter',
          'Dart',
          'Native Android (Java, Kotlin)',
          'Native iOS (Swift)',
        ],
        'Architecture & State Management': [
          'Clean Architecture',
          'MVVM',
          'Repository Pattern',
          'GetX',
          'Provider',
        ],
        'Backend & Services': [
          'REST API Integration',
          'Firebase (Auth, Firestore, FCM)',
        ],
        'Maps & Tracking': [
          'Mapbox',
          'Google Maps',
          'GPS',
          'Geo-fencing',
          'Background Location',
        ],
        'Databases & Tools': [
          'Firebase',
          'SQLite',
          'Git',
          'GitHub',
          'Postman',
        ],
        'Languages': [
          'Dart',
          'Java',
          'Kotlin',
          'C',
          'C++',
          'Python',
        ],
      },
    });
  }

  static Future<void> _createSampleProjects() async {
    final projects = [
      {
        'title': 'Colango — Ride Sharing Platform',
        'description': 'Complete ride-sharing ecosystem with driver and user apps supporting multiple vehicle types',
        'details': 'Ride-sharing system similar to InDrive supporting bike, car, CNG, city and intercity rides, and courier services. Features real-time tracking, dynamic fare calculation, driver bidding system, and comprehensive trip management.',
        'features': [
          'Real-time GPS tracking for drivers and riders',
          'Multiple vehicle type support (Bike, Car, CNG)',
          'City and intercity ride options',
          'Courier and delivery services',
          'Driver bidding system',
          'Dynamic fare calculation',
          'In-app messaging and notifications',
          'Trip history and analytics',
        ],
        'images': [],
        'technologies': ['Flutter', 'Mapbox', 'GPS', 'REST API', 'Firebase', 'GetX'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      },
      {
        'title': 'Oplus Platform',
        'description': 'Multi-service ecosystem with ride booking, food ordering, and shopping features',
        'details': 'Comprehensive multi-service platform including ride booking, food ordering from restaurants, shopping, driver management portal, and seller dashboards. Complete end-to-end solution for multiple business verticals.',
        'features': [
          'Ride booking with real-time tracking',
          'Food ordering and restaurant management',
          'E-commerce shopping integration',
          'Driver management portal',
          'Restaurant and seller dashboards',
          'Order tracking and notifications',
          'Payment gateway integration',
          'Analytics and reporting',
        ],
        'images': [],
        'technologies': ['Flutter', 'Mapbox', 'REST API', 'Firebase', 'GetX'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 60)).toIso8601String(),
      },
      {
        'title': 'Lyfe — Employee Tracking Application',
        'description': 'Always-on background tracking app for employee movement monitoring',
        'details': 'Enterprise-grade employee tracking solution with always-on background location tracking, optimized for battery efficiency. Provides real-time employee location monitoring with detailed movement history and analytics.',
        'features': [
          'Always-on background location tracking',
          'Battery-optimized tracking algorithms',
          'Real-time location updates',
          'Movement history and timeline',
          'Geo-fence alerts',
          'Distance and time tracking',
          'Admin dashboard for monitoring',
          'Detailed analytics and reports',
        ],
        'images': [],
        'technologies': ['Flutter', 'Background Location', 'Mapbox', 'REST API'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
      },
      {
        'title': 'GeoAttend — Location Based Attendance',
        'description': 'Geo-fencing based attendance system with real-time validation',
        'details': 'Smart attendance management system using geo-fencing technology to ensure employees are at the correct location when marking attendance. Includes real-time validation, automated reporting, and admin dashboard.',
        'features': [
          'Geo-fence based attendance marking',
          'Real-time location validation',
          'Automated attendance reports',
          'Leave management',
          'Late arrival notifications',
          'Check-in/check-out tracking',
          'Admin dashboard',
          'Export to Excel/PDF',
        ],
        'images': [],
        'technologies': ['Flutter', 'Mapbox', 'Firebase', 'REST API'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 120)).toIso8601String(),
      },
      {
        'title': 'SalesForce — Field Employee Management',
        'description': 'Complete field force management with task tracking and scheduling',
        'details': 'Comprehensive field employee management system with task assignment, visit scheduling, attendance tracking, and real-time location monitoring. Features calendar-style scheduling and detailed performance analytics.',
        'features': [
          'Task assignment and tracking',
          'Visit scheduling with calendar view',
          'Real-time location tracking',
          'Attendance management',
          'Customer visit history',
          'Photo and note capturing',
          'Performance analytics',
          'Route optimization',
        ],
        'images': [],
        'technologies': ['Flutter', 'REST API', 'Firebase', 'Mapbox'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 150)).toIso8601String(),
      },
      {
        'title': 'FitFlo — Gym Management Ecosystem',
        'description': 'Complete gym management solution with mobile app and web portals',
        'details': 'All-in-one gym management platform with mobile app for members, operator portal for gym staff, and super admin system. Includes workout tracking, subscription management, class scheduling, and comprehensive analytics.',
        'features': [
          'Member mobile app with workout tracking',
          'Operator portal for gym management',
          'Super admin dashboard',
          'Subscription and payment management',
          'Class and trainer scheduling',
          'Workout plans and progress tracking',
          'Member check-in system',
          'Analytics and reporting',
        ],
        'images': [],
        'technologies': ['Flutter (Mobile & Web)', 'Firebase', 'REST API', 'GetX'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 180)).toIso8601String(),
      },
      {
        'title': 'McqXpert — MCQ Exam Preparation',
        'description': 'Comprehensive exam preparation app with mock tests and analytics',
        'details': 'Complete admission test preparation platform with paid packages, unlimited mock exams, flashcards, and detailed result analytics. Features adaptive learning and personalized study plans.',
        'features': [
          'Unlimited mock exams',
          'Paid subscription packages',
          'Flashcard study mode',
          'Detailed result analytics',
          'Performance tracking',
          'Subject-wise categorization',
          'Timed practice tests',
          'Answer explanations',
        ],
        'images': [],
        'technologies': ['Flutter', 'REST API', 'Firebase', 'GetX'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 210)).toIso8601String(),
      },
      {
        'title': 'WelCut — Barber & Salon Booking',
        'description': 'Professional appointment booking platform for barbershops and salons',
        'details': 'Convenient appointment booking app for barbershops and salons with barber selection, service ratings, category-based discovery, and time slot management.',
        'features': [
          'Barber and stylist profiles',
          'Service category browsing',
          'Time slot booking system',
          'Ratings and reviews',
          'Service price listing',
          'Appointment reminders',
          'Gallery of past work',
          'Favorite barber saving',
        ],
        'images': [],
        'technologies': ['Flutter', 'REST API', 'Firebase'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 240)).toIso8601String(),
      },
      {
        'title': 'F1T Trainer — Gym Trainer Booking',
        'description': 'Dedicated platform for gym trainers to manage schedules and bookings',
        'details': 'Trainer-focused application for managing training schedules, client bookings, session tracking, and client progress monitoring. Streamlines the entire trainer-client relationship.',
        'features': [
          'Schedule management',
          'Client booking system',
          'Session tracking',
          'Client progress monitoring',
          'Workout plan creation',
          'Payment tracking',
          'Availability calendar',
          'Client communication',
        ],
        'images': [],
        'technologies': ['Flutter', 'Firebase', 'REST API'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 270)).toIso8601String(),
      },
      {
        'title': 'Relaks Radio (Relaks Media)',
        'description': 'Live radio streaming app with interactive features',
        'details': 'Professional live radio streaming application with admin panel for content management, real-time chat, schedule viewing, and podcast support.',
        'features': [
          'Live radio streaming',
          'Admin content management panel',
          'Real-time listener chat',
          'Program schedule',
          'Podcast library',
          'Favorite show saving',
          'Push notifications for shows',
          'Sleep timer',
        ],
        'images': [],
        'technologies': ['Flutter', 'REST API', 'WebSocket', 'GetX'],
        'projectType': 'mobile',
        'liveUrl': null,
        'githubUrl': '',
        'playStoreUrl': '',
        'appStoreUrl': '',
        'apkUrl': '',
        'createdAt': DateTime.now().subtract(Duration(days: 300)).toIso8601String(),
      },
    ];

    for (var project in projects) {
      await _firestore.collection('projects').add(project);
    }
  }

  static Future<void> _createSampleExperiences() async {
    final experiences = [
      {
        'company': 'TechTrioz Solutions',
        'position': 'Mobile App Developer',
        'description': 'Developed multiple tracking and location-based applications using Flutter. Implemented real-time and background location tracking with geo-fencing. Built location-based attendance and employee monitoring systems. Worked on exam systems, gym management apps, and booking platforms. Integrated REST APIs, Firebase services, Google Maps, and Mapbox.',
        'startDate': 'Feb 2025',
        'endDate': null,
        'isCurrently': true,
      },
      {
        'company': 'FitFlo — Sydney, Australia (Remote)',
        'position': 'Full Stack Flutter Developer',
        'description': 'Developed and maintained Flutter applications for Android, iOS, and Web. Handled production bug fixes, performance optimization, and feature releases. Worked on subscription systems, dashboards, and analytics modules.',
        'startDate': 'Sep 2023',
        'endDate': 'Jan 2025',
        'isCurrently': false,
      },
      {
        'company': 'Texon Ltd — Dhaka, Bangladesh',
        'position': 'Flutter Developer',
        'description': 'Developed a complex social platform with chat, feeds, and file management features.',
        'startDate': 'Mar 2023',
        'endDate': 'Aug 2023',
        'isCurrently': false,
      },
      {
        'company': 'ARS Tech — Rajshahi, Bangladesh',
        'position': 'Flutter Developer Intern',
        'description': 'Gained hands-on experience in developing e-commerce applications and Google Maps integration with functional implementations.',
        'startDate': 'Jan 2023',
        'endDate': 'Feb 2023',
        'isCurrently': false,
      },
    ];

    for (var experience in experiences) {
      await _firestore.collection('experiences').add(experience);
    }
  }

  static Future<void> clearAllData() async {
    final collections = ['projects', 'experiences'];

    for (var collection in collections) {
      final snapshot = await _firestore.collection(collection).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    await _firestore.collection('profile').doc('main').delete();
    print('✅ All data cleared');
  }
}