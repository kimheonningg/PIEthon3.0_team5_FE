import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

String? _foundUserId;

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.v20,
              const Text(
                'Find ID',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v36,
              TextField(
                controller: _phoneNumController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Phone number',
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
                        hintText: 'Last name',
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
                        hintText: 'First name',
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
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('$BASE_URL/auth/find_id');
                  final body = {
                    "phone_num": _phoneNumController.text,
                    "name": {
                      "first_name": _firstNameController.text,
                      "last_name": _lastNameController.text,
                    },
                  };

                  final response = await http.post(
                    url,
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(body),
                  );

                  if (response.statusCode == 200) {
                    final responseData = jsonDecode(response.body);
                    if (responseData["success"] == true) {
                      setState(() {
                        _foundUserId = 'Your ID is: ${responseData["user_id"]}.';
                      });
                    } else {
                      setState(() {
                        _foundUserId = 'Cannot find ID. Please register.';
                      });
                    }
                  } else {
                    setState(() {
                      _foundUserId = 'Cannot find ID. Please register.';
                    });
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
                      'Find',
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
              if (_foundUserId != null) ...[
                Gaps.v20,
                Text(
                  '$_foundUserId',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
