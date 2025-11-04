import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:portfolio/app/data/models/contact_message_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static CollectionReference get profile => _firestore.collection('profile');
  static CollectionReference get skills => _firestore.collection('skills');
  static CollectionReference get experiences =>
      _firestore.collection('experiences');
  static CollectionReference get certifications =>
      _firestore.collection('certifications');
  static CollectionReference get testimonials =>
      _firestore.collection('testimonials');
  static CollectionReference get projects => _firestore.collection('projects');
  static CollectionReference get contactMessages =>
      _firestore.collection('contact_messages');

  // Storage
  static Reference getStorageRef(String path) => _storage.ref(path);

  // Real-time streams
  static Stream<DocumentSnapshot> getProfileStream() {
    return profile.doc('main').snapshots();
  }

  static Stream<QuerySnapshot> getSkillsStream() {
    return skills.orderBy('order').snapshots();
  }

  static Stream<QuerySnapshot> getExperiencesStream() {
    return experiences.orderBy('startDate', descending: true).snapshots();
  }

  static Stream<QuerySnapshot> getCertificationsStream() {
    return certifications.orderBy('order').snapshots();
  }

  static Stream<QuerySnapshot> getTestimonialsStream() {
    return testimonials.orderBy('order').snapshots();
  }

  static Stream<QuerySnapshot> getProjectsStream() {
    return projects.orderBy('order').snapshots();
  }

  static Future<bool> submitContactMessage(ContactMessageModel message) async {
    try {
      await contactMessages.add(message.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }
}
