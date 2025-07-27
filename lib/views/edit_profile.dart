import 'package:flutter/material.dart';
import 'dart:io'; // Untuk File
import 'package:file_picker/file_picker.dart'; // Import package file_picker

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentLocation;
  final String? currentProfileImageUrl; // URL atau path asset

  const EditProfilePage({
    super.key,
    this.currentName = 'Yoga Pratama',
    this.currentBio = 'Owner of Bengkel Udin | Passionate about automotive',
    this.currentLocation = 'Bekasi, West Java',
    this.currentProfileImageUrl = 'assets/profile1.png', // Default asset
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;

  File? _pickedImage; // Untuk menyimpan file gambar yang dipilih
  bool _isLoading = false; // State untuk loading indicator

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _bioController = TextEditingController(text: widget.currentBio);
    _locationController = TextEditingController(text: widget.currentLocation);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih file (khususnya gambar) menggunakan file_picker
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Filter hanya untuk file gambar
        allowMultiple: false, // Hanya izinkan memilih satu file
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedImage = File(result.files.single.path!);
        });
      } else {
        // Pengguna membatalkan pemilihan file atau tidak ada file yang dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pemilihan file dibatalkan atau tidak ada file yang dipilih.',
            ),
          ),
        );
      }
    } catch (e) {
      // Tangani error (misalnya, izin, platform tidak didukung)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih file: $e')));
    }
  }

  // Fungsi untuk menyimpan perubahan
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasikan proses penyimpanan data ke backend
      await Future.delayed(const Duration(seconds: 2));

      // Ambil nilai terbaru dari controller
      String newName = _nameController.text;
      String newBio = _bioController.text;
      String newLocation = _locationController.text;

      // TODO: Kirim data ini ke API atau simpan ke database lokal
      // Misalnya:
      // await ApiService.updateUserProfile(newName, newBio, newLocation, _pickedImage);

      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context, true); // Mengirim `true` sebagai indikasi sukses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfilePictureSection(),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama Anda',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _bioController,
                  labelText: 'Bio / Deskripsi',
                  hintText: 'Ceritakan tentang diri Anda',
                  icon: Icons.info_outline,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _locationController,
                  labelText: 'Lokasi',
                  hintText: 'Contoh: Bekasi, Jawa Barat',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF4F625D))
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F625D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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

  Widget _buildProfilePictureSection() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 70, // Ukuran lebih besar
            backgroundColor: Colors.grey[300],
            backgroundImage: _pickedImage != null
                ? FileImage(_pickedImage!) as ImageProvider<Object>
                : (widget.currentProfileImageUrl != null &&
                              widget.currentProfileImageUrl!.startsWith(
                                'assets/',
                              )
                          ? AssetImage(widget.currentProfileImageUrl!)
                          : (widget.currentProfileImageUrl != null
                                ? NetworkImage(
                                    widget.currentProfileImageUrl!,
                                  ) // Jika ini URL gambar dari server
                                : null))
                      as ImageProvider<
                        Object
                      >?, // Fallback jika tidak ada gambar
            child: _pickedImage == null && widget.currentProfileImageUrl == null
                ? Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey[600],
                  ) // Placeholder icon if no image
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _pickFile, // Panggil fungsi _pickFile yang baru
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F625D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons
                      .camera_alt, // Ganti dengan ikon kamera/edit yang relevan
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4F625D), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
      cursorColor: const Color(0xFF4F625D),
    );
  }
}
