// 로그인 화면
// 일단 가운데 박스는 고정 크기로 해두었습니다
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/functions/user_info_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // id 입력 칸 controller
  final TextEditingController _idController = TextEditingController();
  // 비밀번호 입력 칸 controller
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gaps.v10,
            const Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v36,
            //아이디 박스
            TextField(
              controller: _idController,
              // 입력 텍스트 스타일
              style: const TextStyle(
                color: Colors.white, // 입력되는 글자색
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: 'Please enter your ID',
                hintStyle: const TextStyle(
                  color: MainColors.hinttext, // 힌트 텍스트 색상
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: MainColors.textfield,

                // 테두리 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                // 내부 패딩
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              ),
            ),
            Gaps.v20,
            //비밀번호 입력 칸
            TextField(
              controller: _passwordController,
              obscureText: true,
              // 입력 텍스트 스타일
              style: const TextStyle(
                color: Colors.white, // 입력되는 글자색
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: 'Please enter your password',
                hintStyle: const TextStyle(
                  color: MainColors.hinttext, // 힌트 텍스트 색상
                  fontSize: 16.0,
                ),
                filled: true,
                fillColor: MainColors.textfield,

                // 테두리 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                // 내부 패딩
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              ),
            ),
            Gaps.v20,
            GestureDetector(
              onTap: () async {
                final userId = _idController.text.trim();
                final password = _passwordController.text.trim();

                if (userId.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Please enter your ID and your password")),
                  );
                  return;
                }

                try {
                  final res = await http.post(
                    Uri.parse('$BASE_URL/auth/login'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'user_id': userId, 'password': password}),
                  );

                  if (res.statusCode == 200) {
                    final data = jsonDecode(res.body);
                    final token = data['access_token'];

                    if (token == null || token.isEmpty) {
                      throw Exception('Token missing in response');
                    }

                    print("로그인 성공, token: $token");
                    await TokenManager.saveAccessToken(token);

                    final userInfoRes = await http.get(
                      Uri.parse('$BASE_URL/auth/user_info'),
                      headers: {'Authorization': 'Bearer $token'},
                    );

                    if (userInfoRes.statusCode == 200) {
                      final userInfo =
                          jsonDecode(userInfoRes.body) as Map<String, dynamic>;
                      await UserInfoManager.save(userInfo);
                    } else {
                      await TokenManager.clearAccessToken();
                      throw Exception(
                          'Failed to fetch user info (${userInfoRes.statusCode})');
                    }

                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/patients');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Failed to login: please check your ID or your password.")),
                    );
                  }
                } catch (e) {
                  print("에러 발생: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error in connecting server.")),
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
                    'Login',
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
            Gaps.v12,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login/findID');
                  },
                  child: const Text(
                    'Find ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(
                  ' | ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login/changePW');
                  },
                  child: const Text(
                    'Reset password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Text(
                  ' | ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login/register');
                  },
                  child: const Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
