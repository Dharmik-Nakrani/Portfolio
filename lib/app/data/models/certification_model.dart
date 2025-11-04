class CertificationModel {
  final String id;
  final String name;
  final String imageUrl;
  final String? credlyUrl;
  final int order;

  CertificationModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.credlyUrl,
    required this.order,
  });

  factory CertificationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CertificationModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      credlyUrl: data['credlyUrl'],
      order: data['order'] ?? 0,
    );
  }
}
