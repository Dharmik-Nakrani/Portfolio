import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/app/data/models/project_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/models/skill_model.dart';
import '../../../data/models/experience_model.dart';
import '../../../data/models/certification_model.dart';
import '../../../data/models/testimonial_model.dart';
import '../../../data/services/firebase_service.dart';

class HomeController extends GetxController {
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  // Reactive data
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxList<SkillModel> skills = <SkillModel>[].obs;
  final RxList<ExperienceModel> experiences = <ExperienceModel>[].obs;
  final RxList<CertificationModel> certifications = <CertificationModel>[].obs;
  final RxList<TestimonialModel> testimonials = <TestimonialModel>[].obs;

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxString selectedProjectCategory = 'All'.obs;

  // Add project categories
  final List<String> projectCategories = [
    'All',
    'DevOps',
    'Cloud',
    'Automation',
    'Monitoring',
  ];

  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedSkillCategory = 'DevOps'.obs;

  final List<String> skillCategories = [
    'DevOps',
    'Monitoring',
    'Tools',
    'Database',
    'Programming',
  ];

  // COMPUTED STATS GETTERS
  int get yearsOfExperience {
    // If stored in Firebase, use that
    if (profile.value?.yearsExperience != null) {
      return profile.value!.yearsExperience!;
    }

    return 0;
  }

  int get totalProjects {
    // If stored in Firebase, use that
    if (profile.value?.totalProjects != null) {
      return profile.value!.totalProjects!;
    }

    // Otherwise return count of work experiences (as proxy)
    return experiences.where((exp) => !exp.isEducation).length * 15; // Estimate
  }

  int get totalCertifications {
    // If stored in Firebase, use that
    if (profile.value?.totalCertifications != null) {
      return profile.value!.totalCertifications!;
    }

    // Otherwise return actual count
    return certifications.length;
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    try {
      Future.delayed(const Duration(seconds: 3), () {
        if (isLoading.value) {
          isLoading.value = false;
          hasError.value = true;
          errorMessage.value =
              'Failed to load data. Please check your Firebase connection.';
        }
      });

      FirebaseService.getProfileStream().listen(
        (snapshot) {
          if (snapshot.exists) {
            profile.value = ProfileModel.fromFirestore(
              snapshot.data() as Map<String, dynamic>,
            );
          }
          if (isLoading.value) {
            isLoading.value = false;
          }
        },
        onError: (error) {
          hasError.value = true;
          errorMessage.value = 'Error loading profile data';
          isLoading.value = false;
        },
      );

      FirebaseService.getSkillsStream().listen((snapshot) {
        skills.value = snapshot.docs
            .map(
              (doc) => SkillModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
      }, onError: (error) {});

      FirebaseService.getExperiencesStream().listen((snapshot) {
        experiences.value = snapshot.docs
            .map(
              (doc) => ExperienceModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
      }, onError: (error) {});

      FirebaseService.getCertificationsStream().listen((snapshot) {
        certifications.value = snapshot.docs
            .map(
              (doc) => CertificationModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
      }, onError: (error) {});

      FirebaseService.getTestimonialsStream().listen((snapshot) {
        testimonials.value = snapshot.docs
            .map(
              (doc) => TestimonialModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
      }, onError: (error) {});

      FirebaseService.getProjectsStream().listen((snapshot) {
        projects.value = snapshot.docs
            .map(
              (doc) => ProjectModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
      }, onError: (error) {});
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to initialize Firebase: $e';
      isLoading.value = false;
    }
  }

  List<SkillModel> get filteredSkills {
    return skills
        .where((skill) => skill.category == selectedSkillCategory.value)
        .toList();
  }

  List<ExperienceModel> get educationItems {
    final items = experiences.where((exp) => exp.isEducation).toList();
    items.sort((a, b) => b.order.compareTo(a.order)); // REVERSED: b before a
    return items;
  }

  List<ExperienceModel> get workExperience {
    final items = experiences.where((exp) => !exp.isEducation).toList();
    items.sort((a, b) => b.order.compareTo(a.order)); // REVERSED: b before a
    return items;
  }

  List<ProjectModel> get filteredProjects {
    if (selectedProjectCategory.value == 'All') {
      return projects;
    }
    return projects
        .where((project) => project.category == selectedProjectCategory.value)
        .toList();
  }

  List<ProjectModel> get featuredProjects {
    return projects.where((project) => project.isFeatured).toList();
  }

  void scrollToSection(int index) {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToTop() {
    scrollToSection(0);
  }

  void retryLoading() {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    _loadData();
  }
}
