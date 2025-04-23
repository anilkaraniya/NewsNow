import 'package:flutter/material.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/constants/app_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const routeName = '/info';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.newspaper,
                    size: 80,
                    color: AppColors.surfaceColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'NewsNow',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // Project Overview
          _buildSection(
            context,
            title: 'Project Overview',
            content:
                'NewsNow is a user-generated news application developed as a final year project by Anil Karaniya & Jatin Naiks. The app leverages the power of Flutter for cross-platform functionality and Appwrite as the Backend-as-a-Service (BaaS) solution.',
            icon: Icons.info_outline,
          ),

          // Features
          _buildSection(
            context,
            title: 'Features',
            content: '',
            icon: Icons.star_outline,
            children: [
              _buildFeatureItem(context, 'Real-time News',
                  'Access breaking news published by community members'),
              _buildFeatureItem(context, 'User Contributions',
                  'Share news stories, photos, and videos'),
              _buildFeatureItem(context, 'Personalized Feed',
                  'Customize your news experience based on your interests'),
              _buildFeatureItem(context, 'Community Interaction',
                  'Comment, like, and share news stories'),
              _buildFeatureItem(context, 'Verified Content',
                  'Community-driven fact-checking system'),
              _buildFeatureItem(context, 'Offline Mode',
                  'Read saved articles without internet connection'),
            ],
          ),

          // Technology Stack
          _buildSection(
            context,
            title: 'Technology Stack',
            content: '',
            icon: Icons.code,
            children: [
              _buildTechItem(context, 'Frontend', 'Flutter (Dart)'),
              _buildTechItem(context, 'Backend', 'Appwrite BaaS'),
              _buildTechItem(context, 'Authentication',
                  'Secure user authentication via Appwrite'),
              _buildTechItem(
                  context, 'Storage', 'Cloud storage for media files'),
              _buildTechItem(context, 'Database',
                  'NoSQL database for efficient data retrieval'),
            ],
          ),

          // Developer
          _buildSection(
            context,
            title: 'Developer',
            content:
                'This application was developed by Karaniya Anil & Naik Jatin as part of a final year project in Computer Science.',
            icon: Icons.person_outline,
          ),

          // Connect with the Developer
          _buildSection(
            context,
            title: 'Connect with Developer',
            content: '',
            icon: Icons.connect_without_contact,
            children: [
              _buildSocialItem(
                context,
                'LinkedIn',
                '@anilkaraniya',
                Icons.person,
                AppColors.secondaryColor,
                () => _launchUrl(
                    'https://www.linkedin.com/in/anilkaraniya'),
              ),
              _buildSocialItem(
                context,
                'LinkedIn',
                '@jatin-naik-arvind',
                Icons.person,
                AppColors.secondaryColor,
                    () => _launchUrl(
                      'https://www.linkedin.com/in/jatin-naik-arvind'),
              ),
              _buildSocialItem(
                context,
                'GitHub',
                '@anilkaraniya',
                Icons.code,
                Colors.black87,
                () => _launchUrl('https://github.com/anilkaraniya'),
              ),
              _buildSocialItem(
                context,
                'GitHub',
                '@jatinnaik',
                Icons.code,
                Colors.black87,
                    () => _launchUrl('https://github.com/jatinnaik'),
              ),
              _buildSocialItem(
                context,
                'Email',
                'anilkaraniya21@gmail.com',
                Icons.email,
                AppColors.primaryColor,
                () => _launchUrl('mailto:anilkaraniya21@gmail.com'),
              ),
              _buildSocialItem(
                context,
                'Email',
                'jatinnaik72@gmail.com',
                Icons.email,
                AppColors.primaryColor,
                    () => _launchUrl('mailto:jatinnaik72@gmail.com'),
              ),
              _buildSocialItem(
                context,
                'Twitter',
                '@KaraniyaAnil',
                Icons.alternate_email,
                AppColors.primaryLightColor,
                () => _launchUrl('https://x.com/KaraniyaAnil'),
              ),
              _buildSocialItem(
                context,
                'Twitter',
                '@jatinNaik',
                Icons.alternate_email,
                AppColors.primaryLightColor,
                    () => _launchUrl('https://x.com/jatinNaik'),
              ),
              _buildSocialItem(
                context,
                'Instagram',
                '@nill._.ptll',
                Icons.photo_camera,
                AppColors.accentColor,
                () => _launchUrl('https://instagram.com/nill._.ptll'),
              ),
              _buildSocialItem(
                context,
                'Instagram',
                '@naikjatin72',
                Icons.photo_camera,
                AppColors.accentColor,
                    () => _launchUrl('https://instagram.com/naikjatin72'),
              ),
            ],
          ),

          // Acknowledgements
          _buildSection(
            context,
            title: 'Acknowledgements',
            content: '',
            icon: Icons.favorite_outline,
            children: [
              _buildAcknowledgementItem(
                  context, 'The Flutter development community'),
              _buildAcknowledgementItem(
                  context, 'Appwrite team for their excellent BaaS platform'),
              _buildAcknowledgementItem(context,
                  'Faculty advisors and mentors who guided this project'),
              _buildAcknowledgementItem(
                  context, 'Beta testers who provided valuable feedback'),
            ],
          ),

          // Copyright
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text(
              '© 2025 Anil Karaniya & Jatin Naik.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryColor,
                  ),
            ),
          ),
          SizedBox(height: Sizes.p32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    List<Widget>? children,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                ),
              ],
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.successColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(
      BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_right,
            color: AppColors.secondaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialItem(
    BuildContext context,
    String platform,
    String handle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  handle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcknowledgementItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite,
            color: AppColors.accentColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
