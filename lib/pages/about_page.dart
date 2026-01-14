import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/12345678?v=4', // Ganti dengan foto profil Anda jika ada
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Novan', // Ganti dengan nama Anda
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'novan@example.com', // Ganti dengan email Anda
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'Mahasiswa yang sedang belajar pengembangan aplikasi mobile menggunakan Flutter. Aplikasi BookTime ini dikembangkan sebagai proyek akhir untuk submission Dicoding.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
