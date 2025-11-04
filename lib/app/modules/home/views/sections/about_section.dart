import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class AboutSection extends GetView<HomeController> {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 900;
    
    return Obx(() {
      final profile = controller.profile.value;
      
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 800),
        padding: EdgeInsets.fromLTRB(
          isWide ? 320 : 20,
          80,
          isWide ? 80 : 20,
          80,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDark,
              const Color(0xFF0a0a0a),
            ],
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile 
              ? _buildMobileLayout(profile)
              : _buildDesktopLayout(profile, isWide),
        ),
      );
    });
  }

  Widget _buildMobileLayout(profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ABOUT ME'),
        const SizedBox(height: 40),
        Center(child: _ProfileImageCard(imageUrl: profile?.profileImage)),
        const SizedBox(height: 40),
        _AboutContent(aboutText: profile?.aboutMe ?? ''),
        const SizedBox(height: 40),
        const _SkillHighlights(),
        const SizedBox(height: 40),
        _ContactCards(profile: profile),
      ],
    );
  }

  Widget _buildDesktopLayout(profile, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ABOUT ME'),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Profile Image
            Expanded(
              flex: 2,
              child: _ProfileImageCard(imageUrl: profile?.profileImage),
            ),
            
            SizedBox(width: isWide ? 60 : 40),
            
            // Right: Content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutContent(aboutText: profile?.aboutMe ?? ''),
                  const SizedBox(height: 40),
                  const _SkillHighlights(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        _ContactCards(profile: profile),
      ],
    );
  }
}

// Section Header with animated underline
class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.themeColor,
                    AppColors.themeColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.sectionDescription,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Container(
              height: 3,
              width: 200 * value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.themeColor,
                    AppColors.themeColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Profile Image Card with hover effect
class _ProfileImageCard extends StatefulWidget {
  final String? imageUrl;
  
  const _ProfileImageCard({this.imageUrl});

  @override
  State<_ProfileImageCard> createState() => _ProfileImageCardState();
}

class _ProfileImageCardState extends State<_ProfileImageCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? AppColors.themeColor.withOpacity(0.4)
                    : AppColors.themeColor.withOpacity(0.2),
                blurRadius: _isHovered ? 40 : 20,
                spreadRadius: _isHovered ? 10 : 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 1,
                  child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
                ),
                
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Border
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.themeColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                
                // Hover Icon
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.themeColor.withOpacity(0.1),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: AppColors.themeColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.themeColor.withOpacity(0.2),
            AppColors.themeColor.withOpacity(0.05),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.person_rounded,
          size: 120,
          color: AppColors.themeColor,
        ),
      ),
    );
  }
}

// About Content with typing effect
class _AboutContent extends StatelessWidget {
  final String aboutText;
  
  const _AboutContent({required this.aboutText});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi There! 👋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.themeColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            aboutText.isNotEmpty 
                ? aboutText 
                : 'I\'m a highly passionate and results-driven DevOps engineer with expertise in cloud infrastructure, container orchestration, and CI/CD automation.',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
              color: AppColors.sectionDescription.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

// Skill Highlights with animated bars
class _SkillHighlights extends StatelessWidget {
  const _SkillHighlights();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Core Expertise',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.sectionDescription,
            ),
          ),
          const SizedBox(height: 20),
          const _SkillBar(label: 'Kubernetes & Docker', percentage: 90, delay: 0),
          const _SkillBar(label: 'AWS / Azure / GCP', percentage: 85, delay: 100),
          const _SkillBar(label: 'Terraform & IaC', percentage: 88, delay: 200),
          const _SkillBar(label: 'CI/CD Pipelines', percentage: 92, delay: 300),
        ],
      ),
    );
  }
}

// Animated Skill Bar
class _SkillBar extends StatefulWidget {
  final String label;
  final int percentage;
  final int delay;

  const _SkillBar({
    required this.label,
    required this.percentage,
    required this.delay,
  });

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.percentage / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sectionDescription.withOpacity(0.9),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    '${(_animation.value * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.themeColor,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.themeColor,
                          AppColors.themeColor.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.themeColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Contact Cards with hover animations
class _ContactCards extends StatelessWidget {
  final profile;
  
  const _ContactCards({required this.profile});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _ContactCard(
            icon: Icons.phone_rounded,
            title: 'Phone',
            value: profile?.phone ?? '',
            onTap: () => launchUrl(Uri.parse('tel:${profile?.phone}')),
            gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          _ContactCard(
            icon: Icons.email_rounded,
            title: 'Email',
            value: profile?.email ?? '',
            onTap: () => launchUrl(Uri.parse('mailto:${profile?.email}')),
            gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
          ),
          _ContactCard(
            icon: Icons.location_on_rounded,
            title: 'Location',
            value: profile?.location ?? '',
            gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
        ],
      ),
    );
  }
}

// Individual Contact Card
class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final List<Color> gradient;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    required this.gradient,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: _isHovered
                ? LinearGradient(colors: widget.gradient)
                : null,
            color: _isHovered ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered 
                  ? Colors.transparent 
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.gradient[0].withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? Colors.white.withOpacity(0.2)
                      : widget.gradient[0].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : widget.gradient[0],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: _isHovered 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: _isHovered ? Colors.white : AppColors.sectionDescription,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
