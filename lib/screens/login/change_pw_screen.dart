import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';

class ChangePwScreen extends StatefulWidget {
  const ChangePwScreen({super.key});

  @override
  State<ChangePwScreen> createState() => _ChangePwScreenState();
}

class _ChangePwScreenState extends State<ChangePwScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _originalPwController = TextEditingController();
  final TextEditingController _newPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
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
                'Reset password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _userIdController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: 'ID',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: const TextStyle(
                          color: MainColors.hinttext,
                          fontSize: 16.0,
                        ),
                        filled: true,
                        fillColor: MainColors.textfield,
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
                    child: TextField(
                      controller: _firstNameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: const TextStyle(
                          color: MainColors.hinttext,
                          fontSize: 16.0,
                        ),
                        filled: true,
                        fillColor: MainColors.textfield,
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
              TextField(
                controller: _originalPwController,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              TextField(
                controller: _newPwController,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: const TextStyle(
                    color: MainColors.hinttext,
                    fontSize: 16.0,
                  ),
                  filled: true,
                  fillColor: MainColors.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                ),
              ),
              Gaps.v20,
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('$BASE_URL/auth/change_pw');
                  final body = {
                    "user_id": _userIdController.text,
                    "name": {
                      "first_name": _firstNameController.text,
                      "last_name": _lastNameController.text,
                    },
                    "original_pw": _originalPwController.text,
                    "new_pw": _newPwController.text,
                  };

                  final response = await http.post(
                    url,
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(body),
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resetted your password successfully.')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${response.body}')),
                    );
                  }
                },
                child: Container(
                  width: 480,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: MainColors.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Reset',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
