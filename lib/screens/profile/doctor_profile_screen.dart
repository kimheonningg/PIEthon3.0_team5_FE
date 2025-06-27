import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:piethon_team5_fe/functions/user_info_manager.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _licenceController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final info = await UserInfoManager.load();
    if (info != null) {
      _userIdController.text = info['user_id'] ?? '';
      _emailController.text = info['email'] ?? '';
      _firstNameController.text = info['first_name'] ?? '';
      _lastNameController.text = info['last_name'] ?? '';
      _phoneController.text = info['phone_num'] ?? '';
      _positionController.text = info['position'] ?? '';
      _licenceController.text = info['licence_num'] ?? '';
      _createdAtController.text = (info['created_at'] ?? '').toString().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                        Text(
                          'Go back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.v20,
                const Text(
                  'Doctor Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v36,
                _buildLabeledField('User ID', _userIdController),
                Gaps.v20,
                _buildLabeledField('Email', _emailController),
                Gaps.v20,
                Row(
                  children: [
                    Expanded(child: _buildLabeledField('Last Name', _lastNameController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildLabeledField('First Name', _firstNameController)),
                  ],
                ),
                Gaps.v20,
                _buildLabeledField('Phone Number', _phoneController),
                Gaps.v20,
                _buildLabeledField('Position', _positionController),
                Gaps.v20,
                _buildLabeledField('Licence Number', _licenceController),
                Gaps.v20,
                _buildLabeledField('Account Created At', _createdAtController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gaps.v6,
        TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          decoration: InputDecoration(
            filled: true,
            fillColor: MainColors.textfield,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          ),
        ),
      ],
    );
  }
}
