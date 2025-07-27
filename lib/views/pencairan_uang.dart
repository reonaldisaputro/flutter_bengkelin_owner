import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:flutter_bengkelin_owner/views/notif_pencairan.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  String _amount = '0'; // Initial amount displayed

  // Function to handle number button presses
  void _onNumberTap(String number) {
    setState(() {
      if (_amount == '0' && number != '0') {
        _amount = number;
      } else if (_amount != '0') {
        _amount += number;
      }
    });
  }

  // Function to handle backspace button press
  void _onBackspaceTap() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
        if (_amount.isEmpty) {
          _amount = '0'; // Reset to 0 if all digits are removed
        }
      }
    });
  }

  // Helper to format amount as IDR
  String _formatAmount(String amount) {
    if (amount.isEmpty || amount == '0') return 'Rp.0';
    try {
      // Remove leading zeros for formatting, but keep for actual input
      String cleanAmount = amount;
      if (cleanAmount.length > 1 && cleanAmount.startsWith('0')) {
        cleanAmount = cleanAmount.substring(1);
      }

      // Format with thousands separator
      final parts = <String>[];
      int i = cleanAmount.length - 1;
      while (i >= 0) {
        if (i - 2 >= 0) {
          parts.insert(0, cleanAmount.substring(i - 2, i + 1));
          i -= 3;
        } else {
          parts.insert(0, cleanAmount.substring(0, i + 1));
          break;
        }
      }
      return 'Rp.${parts.join(',')}';
    } catch (e) {
      return 'Rp.$amount'; // Fallback if formatting fails
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // <--- Ensure the whole body content is scrollable
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pak Hambali',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Central Bank',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                '098734638192',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _formatAmount(_amount), // Display formatted amount
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic for "Tarik Uang" button click
                    // Instead of just printing, navigate to WithdrawalSuccessPage
                    Navigator.pushReplacement(
                      // Use pushReplacement
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WithdrawalSuccessPage(),
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Tarik Uang',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Add some space before the keypad
              _buildNumericKeypad(),
              const SizedBox(height: 20), // Bottom padding for the keypad
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        if (index < 9) {
          // Numbers 1-9
          final number = (index + 1).toString();
          return _buildKeypadButton(number);
        } else if (index == 9) {
          // Empty space or placeholder for the '0' row alignment
          return const SizedBox.shrink();
        } else if (index == 10) {
          // Number 0
          return _buildKeypadButton('0');
        } else {
          // Backspace
          return _buildKeypadButton(
            '',
            icon: Icons.backspace_outlined,
            onTap: _onBackspaceTap,
          );
        }
      },
    );
  }

  Widget _buildKeypadButton(
    String text, {
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () => _onNumberTap(text),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: 30, color: Colors.black54)
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}
