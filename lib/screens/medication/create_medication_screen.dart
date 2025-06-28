import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';

class CreateMedicationScreen extends StatefulWidget {
    final String patientMrn;

    const CreateMedicationScreen({
        super.key, required this.patientMrn
    });

  @override
  State<CreateMedicationScreen> createState() => _CreateMedicationScreenState();
}

class _CreateMedicationScreenState extends State<CreateMedicationScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();
  final _tagsController = TextEditingController();
  DateTime? _date;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _createMedication() async {
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    final tags = [
        ..._tagsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty),
        'medication',
    ];

    final token = await TokenManager.getAccessToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login required. Please sign in again.')),
      );
      return;
    }

    final url = Uri.parse('$BASE_URL/medicalhistories/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {
      "medicalhistory_title": _titleController.text,
      "medicalhistory_content": _contentController.text,
      "medicalhistory_date": _date!.toIso8601String(),
      "patient_mrn": widget.patientMrn,
      "tags": tags,
    };
    
    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication created successfully.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create medication. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Go back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                Gaps.v20,
                const Text(
                  'Add Medication',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                ),
                Gaps.v36,
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Medication Title',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                ),
                Gaps.v20,
                TextField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Medication Content',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                ),
                Gaps.v20,
                TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                        hintText: 'Medication Prescribed Date (YYYY-MM-DD)',
                        filled: true,
                        fillColor: MainColors.textfield,
                        hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    ),
                ),
                Gaps.v20,
                TextField(
                  controller: _tagsController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter tags. Separate with commas.',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                ),
                Gaps.v20,
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: MainColors.button),
                    onPressed: _createMedication,
                    child: const Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
