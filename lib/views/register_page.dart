import 'package:flutter/material.dart';
import 'package:flutter_bengkelin_owner/config/model/resp.dart';
import 'package:flutter_bengkelin_owner/model/kecamatan.dart';
import 'package:flutter_bengkelin_owner/model/kelurahan.dart';
import 'package:flutter_bengkelin_owner/viewmodel/auth_viewmodel.dart';
import 'package:flutter_bengkelin_owner/viewmodel/service_viewmodel.dart';
import 'package:flutter_bengkelin_owner/views/login.dart';

class RegisterPageOwner extends StatefulWidget {
  const RegisterPageOwner({super.key});

  @override
  State<RegisterPageOwner> createState() => _RegisterPageOwnerState();
}

class _RegisterPageOwnerState extends State<RegisterPageOwner> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthViewmodel _authViewmodel = AuthViewmodel();
  final ServiceViewmodel _serviceViewmodel = ServiceViewmodel();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  KecamatanModel? _selectedKecamatan;
  KelurahanModel? _selectedKelurahan;

  List<KecamatanModel> _kecamatanList = [];
  List<KelurahanModel> _kelurahanList = [];

  @override
  void initState() {
    super.initState();
    _fetchKecamatanData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchKecamatanData() async {
    setState(() => _isLoading = true);
    try {
      final Resp response = await _serviceViewmodel.kecamatan();

      if (response.code == 200 && response.data is List) {
        setState(() {
          _kecamatanList = (response.data as List)
              .map<KecamatanModel>((json) => KecamatanModel.fromJson(json))
              .toList();
        });
      } else {
        _showSnackBar(response.message ?? 'Gagal memuat data kecamatan.');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan saat mengambil data kecamatan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchKelurahanData(int kecamatanId) async {
    setState(() {
      _isLoading = true;
      _kelurahanList.clear();
      _selectedKelurahan = null;
    });
    try {
      final Resp response = await _serviceViewmodel.kelurahan(
        kecamatanId: kecamatanId,
      );
      if (response.code == 200 && response.data is List) {
        setState(() {
          _kelurahanList = (response.data as List)
              .map<KelurahanModel>((json) => KelurahanModel.fromJson(json))
              .toList();
        });
      } else {
        _showSnackBar(response.message ?? 'Gagal memuat data kelurahan.');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan saat mengambil data kelurahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleRegistration() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Semua field harus diisi.');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Konfirmasi kata sandi tidak cocok.');
      return;
    }

    if (_selectedKecamatan == null || _selectedKelurahan == null) {
      _showSnackBar('Pilih kecamatan dan kelurahan terlebih dahulu.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Resp response = await _authViewmodel.register(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        kecamatanId: _selectedKecamatan?.id,
        kelurahanId: _selectedKelurahan?.id,
      );

      if (response.code == 200) {
        _showSnackBar(response.message ?? 'Pendaftaran berhasil!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPageOwner()),
        );
      } else {
        _showSnackBar(response.message ?? 'Pendaftaran gagal.');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Daftar Akun Mitra',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Daftar akun supaya bisa menggunakan fitur\ndidalam aplikasi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              hintText: 'Nama Lengkap',
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              hintText: 'Alamat Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              hintText: 'Nomor Telepon',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildKecamatanDropdown(),
            const SizedBox(height: 20),
            _buildKelurahanDropdown(),
            const SizedBox(height: 20),
            _buildPasswordField(
              hintText: 'Kata Sandi',
              controller: _passwordController,
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              hintText: 'Konfirmasi Kata Sandi',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F625D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'atau',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () {
                  _showSnackBar(
                    'Masuk dengan Google (Fitur belum diimplementasi)',
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google_logo.png',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Masuk dengan Google',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPageOwner(),
                    ),
                  );
                },
                child: Text(
                  'Sudah memiliki akun? masuk sekarang',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Nanti Saja',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4F625D), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4F625D), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[500],
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  Widget _buildKecamatanDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<KecamatanModel>(
          value: _selectedKecamatan,
          hint: Text(
            'Pilih Kecamatan',
            style: TextStyle(color: Colors.grey[500]),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
          onChanged: (KecamatanModel? newValue) {
            setState(() {
              _selectedKecamatan = newValue;
              _selectedKelurahan = null;
            });
            if (newValue != null) {
              _fetchKelurahanData(newValue.id);
            }
          },
          items: _kecamatanList.map<DropdownMenuItem<KecamatanModel>>((
            KecamatanModel value,
          ) {
            return DropdownMenuItem<KecamatanModel>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildKelurahanDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<KelurahanModel>(
          value: _selectedKelurahan,
          hint: Text(
            'Pilih Kelurahan',
            style: TextStyle(color: Colors.grey[500]),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
          onChanged: _kelurahanList.isEmpty
              ? null
              : (KelurahanModel? newValue) {
                  setState(() {
                    _selectedKelurahan = newValue;
                  });
                },
          items: _kelurahanList.map<DropdownMenuItem<KelurahanModel>>((
            KelurahanModel value,
          ) {
            return DropdownMenuItem<KelurahanModel>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        ),
      ),
    );
  }
}
