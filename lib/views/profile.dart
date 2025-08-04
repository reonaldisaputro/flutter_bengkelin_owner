// lib/views/profile_page.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bengkelin_owner/model/owner_model.dart';
import 'package:flutter_bengkelin_owner/viewmodel/profile_viewmodel.dart';
import 'package:flutter_bengkelin_owner/views/edit_profile.dart';
import 'package:flutter_bengkelin_owner/views/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['My Products', 'My Services', 'Reviews'];

  // State variables for fetching data
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Variable _Owner untuk menyimpan data profil pemilik
  OwnerModel? _Owner;

  // Placeholder user data - mutable for updates
  String _userBio = 'Owner of Bengkel Udin | Passionate about automotive';
  String _userLocation = 'Bekasi, West Java';
  String _profileImageUrl = 'assets/profile1.png'; // Default asset image path
  File? _imageFile;

  final int _totalProducts = 120;
  final int _totalServices = 45;
  final int _totalReviews = 52;
  final double _averageRating = 4.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // Panggil fungsi fetching data saat halaman dimuat
    getUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to pick a file (specifically an image) using file_picker for direct update on ProfilePage
  Future<void> _pickFileForProfilePage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Filter to only allow image files
        allowMultiple: false, // Only allow picking a single file
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _imageFile = File(result.files.single.path!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pemilihan file dibatalkan atau tidak ada file yang dipilih.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih file: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Settings Tapped!')));
            },
          ),
        ],
      ),
      body: _buildBody(), // Menggunakan widget terpisah untuk body
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getUserProfile, // Retry fetching data
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    } else if (_Owner == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Data profil tidak ditemukan.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getUserProfile, // Retry fetching data
              child: const Text('Muat Ulang'),
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 30),
            _buildActionButtons(context),
            const SizedBox(height: 30),
            _buildTabBar(),
            _buildTabContent(),
          ],
        ),
      );
    }
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) as ImageProvider<Object>
                    : AssetImage(_profileImageUrl)
                          as ImageProvider<Object>, // Default asset
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _pickFileForProfilePage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F625D),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _Owner?.name ?? "Nama Pengguna",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 5),
          // Menampilkan email
          Text(
            _Owner?.email ?? "Email tidak tersedia",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5),
          // Menampilkan nomor telepon
          Text(
            _Owner?.phoneNumber ?? "Nomor telepon tidak tersedia",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Products', _totalProducts.toString()),
              _buildStatItem('Services', _totalServices.toString()),
              _buildStatItem('Reviews', _totalReviews.toString()),
              _buildStatItem('Rating', _averageRating.toStringAsFixed(1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentName: _Owner?.name ?? "",
                      currentBio: _userBio,
                      currentLocation: _userLocation,
                      currentProfileImageUrl: _imageFile != null
                          ? _imageFile!.path
                          : _profileImageUrl,
                    ),
                  ),
                );
                if (result != null && result is Map) {
                  setState(() {
                    if (result['name'] != null) {
                      _Owner = OwnerModel(
                        id: _Owner?.id ?? 0,
                        name: result['name'],
                        email: _Owner?.email ?? '',
                        phoneNumber: _Owner?.phoneNumber ?? '',
                      );
                    }
                    _userBio = result['bio'] ?? _userBio;
                    _userLocation = result['location'] ?? _userLocation;
                    if (result['imagePath'] != null) {
                      _imageFile = File(result['imagePath']);
                    } else if (result['imagePath'] == null &&
                        _imageFile != null) {
                      _imageFile = null;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui!'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F625D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Logging out...')));

                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPageOwner(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                });
              },
              icon: const Icon(Icons.logout, color: Color(0xFF4F625D)),
              label: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFF4F625D)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4F625D), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF4F625D),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[700],
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 400, // Fixed height for demonstration; adjust as needed
      child: TabBarView(
        controller: _tabController,
        children: const [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
                Text(
                  'No products added yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.build_circle_outlined, size: 80, color: Colors.grey),
                Text(
                  'No services added yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_outline, size: 80, color: Colors.grey),
                Text('No reviews yet.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> getUserProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _Owner = null;
    });

    try {
      final respValue = await ProfileViewmodel().getOwnerProfile();
      if (!mounted) return;

      if (respValue.code == 200 && respValue.status == 'success') {
        if (respValue.data != null) {
          setState(() {
            _Owner = OwnerModel.fromJson(respValue.data);
            _isLoading = false;
          });
          debugPrint('User profile loaded successfully: ${_Owner?.name}');
        } else {
          setState(() {
            _Owner = null;
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'Data profil tidak valid.';
            debugPrint(
              'Failed to load user profile: Status 200/Success but data is null.',
            );
          });
        }
      } else {
        setState(() {
          _Owner = null;
          _isLoading = false;
          _hasError = true;
          _errorMessage = respValue.message ?? 'Gagal memuat profil.';
          debugPrint(
            'Failed to load user profile: Code ${respValue.code}, Status: ${respValue.status}, Message: ${respValue.error ?? respValue.message}',
          );
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _Owner = null;
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Terjadi kesalahan jaringan atau server.';
        debugPrint('Error loading user profile: $error');
      });
    }
  }
}
