import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/typed_text.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class HeroSection extends GetView<HomeController> {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;

    return Obx(() {
      final profile = controller.profile.value;

      return Container(
        height: size.height,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.bgDark),
        child: Stack(
          children: [
            // Background Image with Error Handling - UPDATED
            if (profile?.heroImage != null && profile!.heroImage.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  profile.heroImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.bgDark,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.themeColor,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('❌ Hero image error: $error');
                    print('Stack trace: $stackTrace');
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.bgDark,
                            AppColors.themeColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              // Fallback gradient background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.bgDark,
                        AppColors.themeColor.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),

            // Dark overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name
                    Text(
                      profile?.name.toUpperCase() ?? 'LOADING...',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: isWide ? 64 : 40,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Typed text
                    if (profile?.typedItems != null &&
                        profile!.typedItems.isNotEmpty)
                      TypedText(
                        items: profile.typedItems,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: isWide ? 28 : 20,
                          fontFamily: 'Lucida Console',
                        ),
                      ),

                    const SizedBox(height: 40),

                    // CTA Buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.scrollToSection(6),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.themeColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'Contact Me',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => controller.scrollToSection(1),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.themeColor,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
