# portfolio

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

portfolio_flutter/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── routes/
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── profile_model.dart
│   │   │   │   ├── skill_model.dart
│   │   │   │   ├── experience_model.dart
│   │   │   │   ├── certification_model.dart
│   │   │   │   └── testimonial_model.dart
│   │   │   ├── services/
│   │   │   │   └── firebase_service.dart
│   │   │   └── repositories/
│   │   │       └── portfolio_repository.dart
│   │   ├── modules/
│   │   │   └── home/
│   │   │       ├── controllers/
│   │   │       │   └── home_controller.dart
│   │   │       ├── views/
│   │   │       │   ├── home_view.dart
│   │   │       │   └── sections/
│   │   │       │       ├── hero_section.dart
│   │   │       │       ├── about_section.dart
│   │   │       │       ├── skills_section.dart
│   │   │       │       ├── experience_section.dart
│   │   │       │       ├── certification_section.dart
│   │   │       │       ├── testimonials_section.dart
│   │   │       │       └── contact_section.dart
│   │   │       └── bindings/
│   │   │           └── home_binding.dart
│   │   ├── widgets/
│   │   │   ├── sidebar.dart
│   │   │   ├── mobile_drawer.dart
│   │   │   ├── typed_text.dart
│   │   │   ├── skill_card.dart
│   │   │   ├── timeline_item.dart
│   │   │   └── back_to_top_button.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       └── app_colors.dart
│   └── firebase_options.dart
└── pubspec.yaml


const firebaseConfig = {
  apiKey: "AIzaSyC0d99fxEdKXPZk_Ovl7ewxbgjLn4sQaJw",
  authDomain: "portfolio-7ea28.firebaseapp.com",
  projectId: "portfolio-7ea28",
  storageBucket: "portfolio-7ea28.firebasestorage.app",
  messagingSenderId: "454375270921",
  appId: "1:454375270921:web:4a6d9e37e43ca5703666d8",
  measurementId: "G-B8GWKTBJPF"
};


portfolio/
├── profile (document)
│   ├── name: "DHARMIK NAKRANI"
│   ├── roles: ["DevOps Engineer", "Flutter Developer", ...]
│   ├── phone: "+919067127486"
│   ├── email: "DharmikN@hotmail.com"
│   ├── location: "Surat, GU, IN-394105"
│   ├── about: "I'm a highly passionate..."
│   └── imageUrl: "profile_image_url"
├── skills (collection)
│   ├── {id} (document)
│   │   ├── name: "AWS"
│   │   ├── category: "DevOps"
│   │   ├── percentage: 70
│   │   └── imageUrl: "skill_icon_url"
├── education (collection)
│   ├── {id} (document)
│   │   ├── degree: "Bachelor of Computer Application"
│   │   ├── institution: "Shri S.V Patel College, Surat"
│   │   ├── duration: "2017 - 2020"
│   │   ├── details: ["Affiliated with VNSGU", ...]
│   │   └── order: 1
├── experience (collection)
│   ├── {id} (document)
│   │   ├── title: "Jr.DevOps Engineer"
│   │   ├── company: "Solution Analyst, Ahmedabad"
│   │   ├── duration: "Jan,2020 - Dec,2022"
│   │   ├── tag: "Cloud/K8s"
│   │   ├── responsibilities: [...]
│   │   └── order: 1
├── certifications (collection)
│   ├── {id} (document)
│   │   ├── name: "AWS Certified"
│   │   ├── badgeUrl: "badge_image_url"
│   │   ├── credlyUrl: "credential_url"
│   │   └── order: 1
└── testimonials (collection)
    ├── {id} (document)
    │   ├── name: "Kiran Pavalla"
    │   ├── location: "USA"
    │   ├── message: "It has been a game-changer..."
    │   ├── imageUrl: "testimonial_image_url"
    │   └── order: 1
