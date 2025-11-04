import 'package:cloud_firestore/cloud_firestore.dart';

class ContactMessageModel {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final DateTime submittedAt;
  final bool isRead;
  final String? status; // 'new', 'read', 'replied'

  ContactMessageModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.submittedAt,
    this.isRead = false,
    this.status = 'new',
  });

  factory ContactMessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ContactMessageModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      status: data['status'] ?? 'new',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'isRead': isRead,
      'status': status,
    };
  }
}
