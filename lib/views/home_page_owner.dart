import 'package:flutter/material.dart';
import 'package:flutter_bengkelin_owner/model/owner_model.dart';
import 'package:flutter_bengkelin_owner/viewmodel/profile_viewmodel.dart';
import 'package:flutter_bengkelin_owner/views/add_product.dart';
import 'package:flutter_bengkelin_owner/views/add_service.dart';
import 'package:flutter_bengkelin_owner/views/pencairan_uang.dart';
import 'package:flutter_bengkelin_owner/views/profile.dart';

class HomePageOwner extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const HomePageOwner({super.key, required this.onNavigateToTab});

  @override
  State<HomePageOwner> createState() => _HomePageOwnerState();
}

class _HomePageOwnerState extends State<HomePageOwner> {
  // Variable _Owner untuk menyimpan data profil pemilik
  OwnerModel? _Owner;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Selamat Datang
              Row(
                children: [
                  GestureDetector(
                    // Wrap CircleAvatar with GestureDetector
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfilePage(), // Navigate to ProfilePage
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/profile1.png', // Ganti dengan path gambar Anda
                      ),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Datang',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        _Owner?.name ?? "",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Nama Bengkel
              const Text(
                'Bengkel Udin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 20),

              // Saldo Pemilik and Rating Section
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saldo Pemilik',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'IDR.100.000',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4F625D),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WithdrawPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF4F625D,
                                  ), // Matches the image
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Cairkan Dana',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15), // Spacer between cards
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '4.0',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < 4 ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '52 Reviews',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Bagian Tambahkan (Add Product, Add Service, Chat)
              const Text(
                'Tambahkan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAddButton(
                    context,
                    icon: Icons.inventory_2_outlined,
                    text: 'Add Product',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductPage(),
                        ),
                      );
                    },
                  ),
                  _buildAddButton(
                    context,
                    icon: Icons.build_circle_outlined,
                    text: 'Add Service',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddServicePage(),
                        ),
                      );
                    },
                  ),
                  _buildAddButton(
                    context,
                    icon: Icons.chat_bubble_outline,
                    text: 'Chat',
                    onTap: () {
                      widget.onNavigateToTab(1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Bagian Grafik Penjualan
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text('Sales'),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.blue[700],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text('Profit'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Placeholder untuk grafik
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Grafik Penjualan (Placeholder)',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Bagian Penjualan (List Produk/Servis)
              const Text(
                'Penjualan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 15),
              _buildSaleItem(
                context,
                imagePath:
                    'assets/kaca_mobil.jpg', // Pastikan gambar ada di assets
                productName: 'Kaca Mobil',
                ownerName: 'Yoga Pratama',
                price: 'Rp 55.000',
              ),
              _buildSaleItem(
                context,
                imagePath:
                    'assets/ban_motor.jpg', // Pastikan gambar ada di assets
                productName: 'Ban',
                ownerName: 'Yoga Pratama',
                price: 'Rp 70.00',
              ),
              _buildSaleItem(
                context,
                imagePath: 'assets/kampas_rem.jpg',
                productName: 'Kampas Rem',
                ownerName: 'Yoga Pratama',
                price: 'Rp 70.00',
              ),
              _buildSaleItem(
                context,
                imagePath: 'assets/oli.jpg',
                productName: 'Oli Motor X78D',
                ownerName: 'Bagus Sucakyo',
                price: 'Rp 55.000',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: const Color(0xFF4F625D)),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaleItem(
    BuildContext context, {
    required String imagePath,
    required String productName,
    required String ownerName,
    required String price,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ownerName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF4F625D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  getUserProfile() async {
    setState(() {
      _Owner = null;
    });

    try {
      final respValue = await ProfileViewmodel().getOwnerProfile();

      if (!mounted) return;

      if (respValue.code == 200 && respValue.status == 'success') {
        if (respValue.data != null) {
          setState(() {
            _Owner = OwnerModel.fromJson(respValue.data);
          });
          debugPrint('User profile loaded successfully: ${_Owner?.name}');
        } else {
          setState(() {
            _Owner = null;
            debugPrint(
              'Failed to load user profile: Status 200/Success but data is null.',
            );
          });
        }
      } else {
        setState(() {
          _Owner = null;
          debugPrint(
            'Failed to load user profile: Code ${respValue.code}, Status: ${respValue.status}, Message: ${respValue.error ?? respValue.message}',
          );
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _Owner = null; // Tangani error jaringan atau lainnya
        debugPrint('Error loading user profile: $error');
      });
    }
  }
}
