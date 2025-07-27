import 'package:flutter/material.dart';

class WithdrawalSuccessPage extends StatelessWidget {
  const WithdrawalSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Background color similar to the image
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Using a Spacer to push content down and button to bottom
            const Spacer(),
            // Replaced Image.asset with an Icon
            const Icon(
              Icons
                  .check_circle_outline, // You can choose different success icons
              size: 150, // Adjust the size as needed
              color: Color(
                0xFF4F625D,
              ), // A success-related color (e.g., green or a brand color)
            ),
            const SizedBox(height: 40), // Space between icon and title
            const Text(
              'Penarikan mu berhasil',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Darker text for title
              ),
            ),
            const SizedBox(height: 15), // Space between title and description
            Text(
              'Withdrawal completed successfully. Funds should reflect in your account according to your payment provider\'s processing times. We appreciate your trust in our services',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700], // Lighter text for description
                height: 1.5, // Line height for better readability
              ),
            ),
            const Spacer(), // Pushes the button to the bottom
            SizedBox(
              width: double.infinity, // Makes the button full width
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation back to home or a different screen
                  // Example: Navigator.popUntil(context, (route) => route.isFirst);
                  // This would typically go back to the main app screen
                  Navigator.pop(context); // For now, just pop back
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F625D), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ), // Button padding
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Text color on button
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Bottom padding for the button
          ],
        ),
      ),
    );
  }
}
