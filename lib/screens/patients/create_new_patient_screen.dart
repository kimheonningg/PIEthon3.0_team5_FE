import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';

class CreateNewPatientScreen extends StatefulWidget {
  const CreateNewPatientScreen({super.key});

  @override
  State<CreateNewPatientScreen> createState() => _CreateNewPatientScreenState();
}

class _CreateNewPatientScreenState extends State<CreateNewPatientScreen> {
  final _phoneNumController = TextEditingController();
  final _patientMrnController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bodyPartController = TextEditingController();
  final _birthdateController = TextEditingController();
  DateTime? _birthdate;
  String _selectedGender = 'Female';
  bool _isMyPatient = true;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _phoneNumController.dispose();
    _patientMrnController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _bodyPartController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthdate = picked;
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _createPatient() async {
    final age = int.tryParse(_ageController.text);
    if (age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }
    if (_birthdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a birthdate')),
      );
      return;
    }

    final bodyParts = _bodyPartController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final token = await TokenManager.getAccessToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login required. Please sign in again.')),
      );
      return;
    }

    final url = Uri.parse('$BASE_URL/patients/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {
      "phone_num": _phoneNumController.text,
      "patient_mrn": _patientMrnController.text,
      "name": {
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
      },
      "age": age,
      "birthdate": _birthdate!.toIso8601String(),
      "gender": _selectedGender,
      "body_part": bodyParts,
      "ai_ready": _isMyPatient,
    };

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        if (_isMyPatient) {
          final assignUrl = Uri.parse('$BASE_URL/patients/assign/${_patientMrnController.text}');
          final assignResponse = await http.post(assignUrl, headers: headers);
          if (assignResponse.statusCode != 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to assign patient to your care.')),
            );
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient created successfully.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create patient. Please try again.')),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Go back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                Gaps.v20,
                const Text(
                  'Create New Patient',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                ),
                Gaps.v36,
                TextField(
                  controller: _phoneNumController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                ),
                Gaps.v20,
                TextField(
                  controller: _patientMrnController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'MRN',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                ),
                Gaps.v20,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _lastNameController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          filled: true,
                          fillColor: MainColors.textfield,
                          hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _firstNameController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'First name',
                          filled: true,
                          fillColor: MainColors.textfield,
                          hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
                Row(
                  children: [
                    Expanded(
                      flex: 1, 
                      child: TextField(
                        controller: _ageController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Age',
                          filled: true,
                          fillColor: MainColors.textfield,
                          hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2, 
                      child: TextField(
                        controller: _birthdateController,
                        readOnly: true,
                        onTap: _pickBirthdate,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Birthdate (YYYY-MM-DD)',
                          filled: true,
                          fillColor: MainColors.textfield,
                          hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(color: Colors.white))))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v!),
                  decoration: InputDecoration(
                    hintText: 'Gender',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                  dropdownColor: MainColors.textfield,
                ),
                Gaps.v20,
                TextField(
                  controller: _bodyPartController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter body parts. Separate with commas.',
                    filled: true,
                    fillColor: MainColors.textfield,
                    hintStyle: const TextStyle(color: MainColors.hinttext, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  ),
                ),
                Gaps.v20,
                Row(
                  children: [
                    Checkbox(
                      value: _isMyPatient,
                      onChanged: (v) => setState(() => _isMyPatient = v ?? false),
                      checkColor: Colors.white,
                      activeColor: MainColors.button,
                    ),
                    const Text('Assign this patient under my care.', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
                Gaps.v20,
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: MainColors.button),
                    onPressed: _createPatient,
                    child: const Text('Create', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
