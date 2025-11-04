class SkillModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final int percentage;
  final int order;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.percentage,
    required this.order,
  });

  factory SkillModel.fromFirestore(String id, Map<String, dynamic> data) {
    return SkillModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'DevOps',
      imageUrl: data['imageUrl'] ?? '',
      percentage: data['percentage'] ?? 0,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'percentage': percentage,
      'order': order,
    };
  }
}
