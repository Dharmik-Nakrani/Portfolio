import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  
  // Loading states
  final RxBool isLoading = true.obs;
  final RxString selectedSkillCategory = 'DevOps'.obs;
  
  // Skill categories
  final List<String> skillCategories = [
    'DevOps',
    'Monitoring',
    'Tools',
    'Database',
    'Programming'
  ];
  
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  
  void _loadData() {
    // Listen to profile changes
    FirebaseService.getProfileStream().listen((snapshot) {
      if (snapshot.exists) {
        profile.value = ProfileModel.fromFirestore(
          snapshot.data() as Map<String, dynamic>,
        );
      }
    });
    
    // Listen to skills changes
    FirebaseService.getSkillsStream().listen((snapshot) {
      skills.value = snapshot.docs
          .map((doc) => SkillModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
      isLoading.value = false;
    });
    
    // Listen to experiences changes
    FirebaseService.getExperiencesStream().listen((snapshot) {
      experiences.value = snapshot.docs
          .map((doc) => ExperienceModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    });
    
    // Listen to certifications changes
    FirebaseService.getCertificationsStream().listen((snapshot) {
      certifications.value = snapshot.docs
          .map((doc) => CertificationModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    });
    
    // Listen to testimonials changes
    FirebaseService.getTestimonialsStream().listen((snapshot) {
      testimonials.value = snapshot.docs
          .map((doc) => TestimonialModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    });
  }
  
  List<SkillModel> get filteredSkills {
    return skills.where((skill) => skill.category == selectedSkillCategory.value).toList();
  }
  
  List<ExperienceModel> get educationItems {
    return experiences.where((exp) => exp.isEducation).toList();
  }
  
  List<ExperienceModel> get workExperience {
    return experiences.where((exp) => !exp.isEducation).toList();
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
}
