import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class ContactSection extends GetView<HomeController> {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        image: const DecorationImage(
          image: AssetImage('assets/img/subscribe-bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        isWide ? 300 : 20,
        80,
        isWide ? 80 : 20,
        100,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'CONTACT ME'),
            const SizedBox(height: 32),
            const _ContactForm(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.themeColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _ContactForm extends GetView<HomeController> {
  const _ContactForm();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();
    
    final isWide = MediaQuery.of(context).size.width >= 900;
    
    return Obx(() {
      final profile = controller.profile.value;
      
      return isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildForm(
                    formKey,
                    nameController,
                    emailController,
                    messageController,
                    context,
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _buildContactInfo(profile, context),
                ),
              ],
            )
          : Column(
              children: [
                _buildForm(
                  formKey,
                  nameController,
                  emailController,
                  messageController,
                  context,
                ),
                const SizedBox(height: 32),
                _buildContactInfo(profile, context),
              ],
            );
    });
  }

  Widget _buildForm(
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController messageController,
    BuildContext context,
  ) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: nameController,
            label: 'Your Name',
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Required';
              if (!GetUtils.isEmail(v!)) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: messageController,
            label: 'Message',
            maxLines: 5,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Get.snackbar(
                  'Success',
                  'Message sent successfully!',
                  backgroundColor: AppColors.themeColor,
                  colorText: Colors.white,
                );
                nameController.clear();
                emailController.clear();
                messageController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.themeColor,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'SEND MESSAGE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.themeColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildContactInfo(profile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get In Touch',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        _contactInfoItem(
          Icons.phone,
          'Phone',
          profile?.phone ?? '',
          () => launchUrl(Uri.parse('tel:${profile?.phone}')),
        ),
        const SizedBox(height: 16),
        _contactInfoItem(
          Icons.email,
          'Email',
          profile?.email ?? '',
          () => launchUrl(Uri.parse('mailto:${profile?.email}')),
        ),
        const SizedBox(height: 16),
        _contactInfoItem(
          Icons.location_on,
          'Location',
          profile?.location ?? '',
          null,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            _socialButton(Icons.business, 'linkedin.com', () {}),
            const SizedBox(width: 12),
            _socialButton(Icons.code, 'github.com', () {}),
            const SizedBox(width: 12),
            _socialButton(Icons.chat, 'WhatsApp', () {}),
          ],
        ),
      ],
    );
  }

  Widget _contactInfoItem(
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.themeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.themeColor,
        side: const BorderSide(color: AppColors.themeColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
