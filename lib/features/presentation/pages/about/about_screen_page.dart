import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'arjunkrishnaraj5@gmail.com',
      query: 'subject=BeaverApp Feedback',
    );
    
    try {
      await launchUrl(emailUri);
    } catch (e) {
      // Handle error
      debugPrint('Could not launch email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About BeaverApp'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // App logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App name
            Text(
              'BeaverApp',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // App version
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            const SizedBox(height: 32),
            
            // App description
            const Text(
              'BeaverApp helps you stay connected with friends and family through seamless messaging and video calls.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Developer info
            const Text(
              'Developed by',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Arjun K',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact button
            ElevatedButton.icon(
              onPressed: _launchEmail,
              icon: const Icon(Icons.email_outlined),
              label: const Text('Contact Developer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Privacy and terms
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to privacy policy
                  },
                  child: const Text('Privacy Policy'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to terms of service
                  },
                  child: const Text('Terms of Service'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Copyright text
            Text(
              '© ${DateTime.now().year} BeaverApp. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}