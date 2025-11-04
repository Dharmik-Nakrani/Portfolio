import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class CertificationSection extends GetView<HomeController> {
  const CertificationSection({super.key});

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
        80,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'CERTIFICATIONS'),
            const SizedBox(height: 32),
            
            Obx(() {
              final certs = controller.certifications;
              
              if (certs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: certs.map((cert) => _CertificationCircle(
                  name: cert.name,
                  imageUrl: cert.imageUrl,
                  onTap: cert.credlyUrl != null 
                      ? () => launchUrl(Uri.parse(cert.credlyUrl!))
                      : null,
                )).toList(),
              );
            }),
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

class _CertificationCircle extends StatefulWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  const _CertificationCircle({
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  @override
  State<_CertificationCircle> createState() => _CertificationCircleState();
}

class _CertificationCircleState extends State<_CertificationCircle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered ? AppColors.themeColor : Colors.white.withOpacity(0.3),
              width: 3,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.themeColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (_isHovered)
                  Container(
                    color: AppColors.themeColor.withOpacity(0.8),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
}
