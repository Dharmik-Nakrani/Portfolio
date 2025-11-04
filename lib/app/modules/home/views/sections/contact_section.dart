import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/app/data/models/contact_message_model.dart';
import 'package:portfolio/app/data/services/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class ContactSection extends GetView<HomeController> {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 900),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0a0a0a),
            AppColors.bgDark,
            const Color(0xFF0a0a0a),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Grid Background
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              isWide ? 120 : 20,
              80,
              isWide ? 80 : 20,
              100,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'GET IN TOUCH'),
                  const SizedBox(height: 20),
                  Text(
                    'Let\'s discuss your next project',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: AppColors.sectionDescription.withValues(
                        alpha: 0.7,
                      ),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Main Content
                  if (isMobile)
                    _buildMobileLayout()
                  else
                    _buildDesktopLayout(isWide),

                  const SizedBox(height: 60),

                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [_ContactInfo(), const SizedBox(height: 40), _ContactForm()],
    );
  }

  Widget _buildDesktopLayout(bool isWide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _ContactForm()),
        SizedBox(width: isWide ? 60 : 40),
        Expanded(flex: 1, child: _ContactInfo()),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.copyright_rounded,
                size: 16,
                color: AppColors.sectionDescription.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Text(
                '2025 Dharmik Nakrani. All rights reserved.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.sectionDescription.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Built with Flutter & Firebase',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.themeColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Grid Background Painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.themeColor.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Section Header
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
                    AppColors.themeColor.withValues(alpha: 0.3),
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
                    AppColors.themeColor.withValues(alpha: 0.3),
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

// Contact Form
class _ContactForm extends StatefulWidget {
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      try {
        // Create contact message
        final contactMessage = ContactMessageModel(
          id: '', // Will be generated by Firestore
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          subject: _subjectController.text.trim(),
          message: _messageController.text.trim(),
          submittedAt: DateTime.now(),
        );

        // Submit to Firebase
        final success = await FirebaseService.submitContactMessage(
          contactMessage,
        );

        if (success && mounted) {
          // Show success message
          Get.snackbar(
            'Success! 🎉',
            'Thank you for your message! I\'ll get back to you soon.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );

          // Clear form
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();

          // Reset form validation
          _formKey.currentState?.reset();
        } else if (mounted) {
          // Show error message
          Get.snackbar(
            'Error',
            'Failed to send message. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      } catch (e) {
        if (mounted) {
          Get.snackbar(
            'Error',
            'Something went wrong. Please try again later.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.05),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.send_rounded,
                    color: AppColors.themeColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.sectionDescription,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _nameController,
                label: 'Your Name',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Name is required' : null,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Email is required';
                  if (!GetUtils.isEmail(v!)) return 'Invalid email address';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: _subjectController,
                label: 'Subject',
                icon: Icons.subject_rounded,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Subject is required' : null,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: _messageController,
                label: 'Your Message',
                icon: Icons.message_outlined,
                maxLines: 5,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Message is required';
                  if (v!.length < 10) {
                    return 'Message must be at least 10 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      enabled: !_isSubmitting, // Disable during submission
      style: const TextStyle(color: AppColors.sectionDescription, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.sectionDescription.withValues(alpha: 0.6),
        ),
        prefixIcon: Icon(icon, color: AppColors.themeColor),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.themeColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: _isSubmitting ? 0 : 5,
        shadowColor: AppColors.themeColor.withValues(alpha: 0.5),
        disabledBackgroundColor: AppColors.themeColor.withValues(alpha: 0.5),
      ),
      child: _isSubmitting
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'SENDING...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.send_rounded, size: 20),
                SizedBox(width: 12),
                Text(
                  'SEND MESSAGE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
    );
  }
}

// Contact Info
class _ContactInfo extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Obx(() {
        final profile = controller.profile.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.sectionDescription,
              ),
            ),
            const SizedBox(height: 24),

            _InfoCard(
              icon: Icons.phone_rounded,
              title: 'Phone',
              value: profile?.phone ?? '+91 90671 27486',
              onTap: () => launchUrl(Uri.parse('tel:${profile?.phone}')),
              gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
            ),

            const SizedBox(height: 16),

            _InfoCard(
              icon: Icons.email_rounded,
              title: 'Email',
              value: profile?.email ?? 'dharmik@example.com',
              onTap: () => launchUrl(Uri.parse('mailto:${profile?.email}')),
              gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
            ),

            const SizedBox(height: 16),

            _InfoCard(
              icon: Icons.location_on_rounded,
              title: 'Location',
              value: profile?.location ?? 'Surat, India',
              gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
            ),

            const SizedBox(height: 32),

            Text(
              'Follow Me',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.sectionDescription,
              ),
            ),

            const SizedBox(height: 16),

            if (profile?.socialLinks != null)
              _buildSocialLinks(profile!.socialLinks),
          ],
        );
      }),
    );
  }

  Widget _buildSocialLinks(Map<String, String> links) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (links['linkedin'] != null)
          _SocialButton(
            iconPath: 'assets/icons/linkedin.png',
            label: 'LinkedIn',
            url: links['linkedin']!,
            color: const Color(0xFF0077B5),
          ),
        if (links['github'] != null)
          _SocialButton(
            iconPath: 'assets/icons/github.png',
            label: 'GitHub',
            url: links['github']!,
            color: const Color(0xFF333333),
          ),
        if (links['twitter'] != null)
          _SocialButton(
            iconPath: 'assets/icons/twitter.png',
            label: 'Twitter',
            url: links['twitter']!,
            color: const Color(0xFF1DA1F2),
          ),
        if (links['whatsapp'] != null)
          _SocialButton(
            iconPath: 'assets/icons/whatsapp.png',
            label: 'WhatsApp',
            url: links['whatsapp']!,
            color: const Color(0xFF25D366),
          ),
      ],
    );
  }
}

// Info Card
class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final List<Color> gradient;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    required this.gradient,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: _isHovered
                ? LinearGradient(colors: widget.gradient)
                : null,
            color: _isHovered ? null : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.gradient[0].withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? Colors.white.withValues(alpha: 0.2)
                      : widget.gradient[0].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : widget.gradient[0],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: _isHovered
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: TextStyle(
                        color: _isHovered
                            ? Colors.white
                            : AppColors.sectionDescription,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Social Button
class _SocialButton extends StatefulWidget {
  final String iconPath; // Changed from IconData to String for asset path
  final String label;
  final String url;
  final Color color;

  const _SocialButton({
    required this.iconPath,
    required this.label,
    required this.url,
    required this.color,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color
                : widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withValues(alpha: _isHovered ? 0 : 0.3),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PNG Image Icon
              Image.asset(
                widget.iconPath,
                width: 20,
                height: 20,
                color: _isHovered ? Colors.white : widget.color,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to a default icon if image fails to load
                  return Icon(
                    Icons.link,
                    color: _isHovered ? Colors.white : widget.color,
                    size: 20,
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _isHovered ? Colors.white : widget.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
