import 'package:flutter/material.dart';
import 'dart:io'; // Required for File
import 'package:file_picker/file_picker.dart'; // Import the file_picker package
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

  // Placeholder user data - mutable for updates
  String _userName = 'Yoga Pratama';
  String _userBio = 'Owner of Bengkel Udin | Passionate about automotive';
  String _userLocation = 'Bekasi, West Java';
  String _profileImageUrl = 'assets/profile1.png'; // Default asset image path
  File?
  _imageFile; // To store the picked image file (if picked directly from ProfilePage or returned from EditProfilePage)

  // Placeholder stats (can be updated later if your data model allows)
  final int _totalProducts = 120;
  final int _totalServices = 45;
  final int _totalReviews = 52;
  final double _averageRating = 4.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
          // In a real app, you would typically upload this image to a server here
          // and then update _profileImageUrl with the URL returned by the server.
          // For this example, we directly use _imageFile for display.
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
      body: SingleChildScrollView(
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
      ),
    );
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
                // Conditionally display image: first from _imageFile (if locally picked/updated),
                // then from _profileImageUrl (default asset or network URL)
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) as ImageProvider<Object>
                    : AssetImage(_profileImageUrl)
                          as ImageProvider<Object>, // Default asset
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap:
                      _pickFileForProfilePage, // Use file_picker for direct edit on ProfilePage
                  child: Container(
                    padding: EdgeInsets.all(6),
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
            _userName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _userBio,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 5),
              Text(
                _userLocation,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
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
                // Navigasi ke EditProfilePage dan tunggu hasilnya
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentName: _userName,
                      currentBio: _userBio,
                      currentLocation: _userLocation,
                      // Teruskan path gambar yang saat ini ditampilkan.
                      // Jika _imageFile tidak null, itu berarti gambar telah diubah secara lokal di ProfilePage
                      // atau sebelumnya di EditProfilePage. Gunakan path file tersebut.
                      // Jika tidak, gunakan _profileImageUrl yang merupakan default asset atau URL.
                      currentProfileImageUrl: _imageFile != null
                          ? _imageFile!.path
                          : _profileImageUrl,
                    ),
                  ),
                );

                // Jika ada hasil yang dikembalikan dan menunjukkan pembaruan sukses
                if (result != null && result is Map) {
                  setState(() {
                    _userName = result['name'] ?? _userName;
                    _userBio = result['bio'] ?? _userBio;
                    _userLocation = result['location'] ?? _userLocation;
                    // Perbarui _imageFile jika ada path gambar baru dari EditProfilePage
                    if (result['imagePath'] != null) {
                      _imageFile = File(result['imagePath']);
                    } else if (result['imagePath'] == null &&
                        _imageFile != null) {
                      // Case: Gambar dihapus atau dikembalikan ke default di EditProfilePage
                      // Anda mungkin perlu logika tambahan di sini
                      // Misalnya, jika 'imagePath' null, reset _imageFile dan _profileImageUrl ke default
                      _imageFile = null;
                      // _profileImageUrl = 'assets/profile1.png'; // Atau URL default Anda
                    }
                    // Jika Anda menggunakan _profileImageUrl dari URL server, update di sini juga
                    // _profileImageUrl = result['imageUrl'] ?? _profileImageUrl;
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

                // Simulate a logout process (e.g., clearing user session/token from SharedPreferences/Hive)
                // In a real app, you would clear user session, token, etc. here before navigating.
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPageOwner(),
                    ),
                    (Route<dynamic> route) =>
                        false, // This line removes all previous routes
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
}
