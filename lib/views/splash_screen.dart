import 'package:flutter/material.dart';
import 'package:flutter_bengkelin_owner/views/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F1F5,
      ), // Warna latar belakang sesuai gambar
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Image section
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height:
                      MediaQuery.of(context).size.height *
                      0.35, // Tinggi gambar sesuai proporsi
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        // Gambar utama
                        Image.asset(
                          'assets/mekanik.jpg', // Ganti dengan gambar mekanik Anda
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        // Overlay dengan emoji (jika ada gambar emoji, atau gunakan Text dengan emoji langsung)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  '👨‍🔧',
                                  style: TextStyle(fontSize: 20),
                                ), // Emoji mekanik
                                SizedBox(width: 5),
                                Text(
                                  '💼',
                                  style: TextStyle(fontSize: 20),
                                ), // Emoji tas kerja
                                SizedBox(width: 5),
                                Text(
                                  '�',
                                  style: TextStyle(fontSize: 20),
                                ), // Emoji jempol
                              ],
                            ),
                          ),
                        ),
                        // Overlay "Great People!!"
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Great\nPeople!!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                // Text section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Make',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E), // Warna gelap
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        'Better',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F625D), // Warna hijau gelap
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        'Cars',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E), // Warna gelap
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Find high quality people to take care\nof your own house to live better', // Teks deskripsi
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                // Buttons section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigasi ke halaman Login User
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPageOwner(), // Mengarah ke LoginPage (User)
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF4F625D,
                            ), // Warna tombol Sign In user
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Sign In Here !!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Mengurangi spasi karena satu tombol dihapus
                      TextButton(
                        onPressed: () {
                          // Navigasi ke halaman register
                          // Anda bisa membuat halaman register terpisah atau menggunakan halaman login dengan opsi register
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigasi ke halaman Register'),
                            ),
                          );
                        },
                        child: Text(
                          'Dont have account?, register',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
