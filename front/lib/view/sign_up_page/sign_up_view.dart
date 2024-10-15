import 'package:brr/controller/signup_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/driver_signup_page_controller.dart';

class SignUpPageView extends StatefulWidget {
  const SignUpPageView({super.key});

  @override
  State<SignUpPageView> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPageView> {
  final _controller = Get.put(UserSignUpPageController());
  final _drivercontroller = Get.put(DriverSignUpPageController());

  bool isNormalAcc = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  brrLogo(),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isNormalAcc = true;
                          });
                        },
                        child: Text(
                          '회원으로 가입',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isNormalAcc ? Colors.black : Colors.grey),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 14.5,
                        color: Colors.black,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isNormalAcc = false;
                          });
                        },
                        child: Text(
                          '택시기사로 가입',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isNormalAcc ? Colors.grey : Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  isNormalAcc ? NormalSignUp(controller: _controller) : DriverSignUp(controller: _drivercontroller),
                  const SizedBox(height: 33),
                  SizedBox(
                    width: 270,
                    child: OutlinedButton(
                      onPressed: () {
                        isNormalAcc ? _controller.signupButton(isNormalAcc) : _drivercontroller.signupButton(isNormalAcc);
                      },
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('가입하기', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 270,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed("/login");
                          },
                          child: const Text(
                            '로그인',
                            style: TextStyle(fontSize: 12, color: Color(0xff767676), decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class NormalSignUp extends StatefulWidget {
  final UserSignUpPageController controller;

  const NormalSignUp({required this.controller, super.key});
  @override
  State<NormalSignUp> createState() => _NormalSignUpState();
}

class _NormalSignUpState extends State<NormalSignUp> {
  bool _isPasswordHidden = true;
  bool _isPasswordCheckHidden = true;
  bool _isVerificationCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        logInTextField('이름', widget.controller.nicknameController),
        logInTextField('아이디', widget.controller.idController),
        logInPWTextField('비밀번호', widget.controller.pwdController, _isPasswordHidden, () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          });
        }),
        logInPWTextField('비밀번호 확인', widget.controller.pwdCheckController, _isPasswordCheckHidden, () {
          setState(() {
            _isPasswordCheckHidden = !_isPasswordCheckHidden;
          });
        }),
        logInTextField('전화번호', widget.controller.phoneNumberController),
        logInTextField('학번', widget.controller.classNumberController),
        logInEmailField('이메일', '전송', widget.controller.emailController),
        logInEmailField('인증번호', '인증', widget.controller.emailCodeController),
      ],
    );
  }

  Widget logInEmailField(String labelText, String button, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 210,
            height: 48,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xffCCE0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
                obscureText: false,
                controller: controller,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: const TextStyle(fontSize: 14),
                  contentPadding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  border: InputBorder.none,
                ))),
        Container(
            width: 50,
            height: 48,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            child: TextButton(
              onPressed: () {
                if (labelText == '이메일') {
                  widget.controller.sendVerificationCode();
                } else if (labelText == '인증번호') {
                  widget.controller.checkVerificationCode();
                }
              },
              style: TextButton.styleFrom(minimumSize: Size.zero),
              child: Text(
                button,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
              ),
            )),
      ],
    );
  }
}

class DriverSignUp extends StatefulWidget {
  final DriverSignUpPageController controller;

  const DriverSignUp({required this.controller, super.key});
  @override
  State<DriverSignUp> createState() => _DriverSignUpState();
}

class _DriverSignUpState extends State<DriverSignUp> {
  bool _isPasswordHidden = true;
  bool _isPasswordCheckHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        logInTextField('이름', widget.controller.nicknameController),
        logInTextField('아이디', widget.controller.idController),
        logInPWTextField('비밀번호', widget.controller.pwdController, _isPasswordHidden, () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          });
        }),
        logInPWTextField('비밀번호 확인', widget.controller.pwdCheckController, _isPasswordCheckHidden, () {
          setState(() {
            _isPasswordCheckHidden = !_isPasswordCheckHidden;
          });
        }),
        logInTextField('전화번호', widget.controller.phoneNumberController),
        logInTextField('차량번호', widget.controller.carNumberController),
        logInTextField('차종', widget.controller.carModelController),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(minimumSize: Size.zero),
          child: const Text(
            '운수사업자등록번호 확인 >',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(minimumSize: Size.zero),
          child: const Text(
            '면허증 인증 >',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
