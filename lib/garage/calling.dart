import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicCallScreen extends StatefulWidget {

  const DynamicCallScreen({
    super.key,
    required this.phoneNumber,
  });
  final String phoneNumber;

  @override
  State<DynamicCallScreen> createState() => _DynamicCallScreenState();
}

class _DynamicCallScreenState extends State<DynamicCallScreen> {
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the text field with the passed phone number
    _numberController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  // Function to make a call
  Future<void> _makePhoneCall(String number) async {
    // Remove any non-digit characters except +
    final cleanedNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanedNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch call to $cleanedNumber')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making call: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Call Screen'),
        backgroundColor: const Color.fromARGB(255, 90, 12, 174),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '+91 9876543210',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: widget.phoneNumber.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _numberController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            if (widget.phoneNumber.isNotEmpty) ...[
              Text(
                'Passed number: ${widget.phoneNumber}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
            ],
            ElevatedButton.icon(
              onPressed: _numberController.text.trim().isEmpty
                  ? null
                  : () {
                      _makePhoneCall(_numberController.text.trim());
                    },
              icon: const Icon(Icons.call),
              label: const Text('Call Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 68, 9, 140),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 20),
            // Quick call button for the passed number
            if (widget.phoneNumber.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () {
                  _makePhoneCall(widget.phoneNumber);
                },
                icon: const Icon(Icons.phone_android),
                label: Text('Call ${widget.phoneNumber}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 68, 9, 140),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 68, 9, 140),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}