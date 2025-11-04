class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> techStack;
  final String? liveUrl;
  final String? githubUrl;
  final String category; // e.g., "DevOps", "Web", "Mobile"
  final bool isFeatured;
  final int order;
  final String createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.techStack,
    this.liveUrl,
    this.githubUrl,
    required this.category,
    this.isFeatured = false,
    required this.order,
    required this.createdAt,
  });

  factory ProjectModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProjectModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      techStack: List<String>.from(data['techStack'] ?? []),
      liveUrl: data['liveUrl'],
      githubUrl: data['githubUrl'],
      category: data['category'] ?? 'Other',
      isFeatured: data['isFeatured'] ?? false,
      order: data['order'] ?? 0,
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'techStack': techStack,
      'liveUrl': liveUrl,
      'githubUrl': githubUrl,
      'category': category,
      'isFeatured': isFeatured,
      'order': order,
      'createdAt': createdAt,
    };
  }
}
