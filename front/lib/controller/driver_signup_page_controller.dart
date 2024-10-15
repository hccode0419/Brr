import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:brr/constants/url.dart';

class DriverSignUpPageController extends GetxController {
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  final pwdCheckController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final carNumberController = TextEditingController();
  final carModelController = TextEditingController();

  final RegExp idPwdRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  final RegExp generalRegExp = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]+$');

  void signupButton(bool userType) async {
    String apiUrl = '${Urls.apiUrl}user/signin_taxi';
    try {
      // 모든 필드가 비어있는 경우 처리
      if (idController.text.isEmpty ||
          pwdController.text.isEmpty ||
          pwdCheckController.text.isEmpty ||
          nicknameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          carNumberController.text.isEmpty ||
          carModelController.text.isEmpty) {
        Get.snackbar(
          '회원가입 실패',
          '모든 칸을 채워주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 비밀번호 일치 여부 확인
      if (pwdController.text != pwdCheckController.text) {
        Get.snackbar(
          '회원가입 실패',
          '비밀번호가 일치하지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 아이디와 비밀번호 유효성 검사
      if (!idPwdRegExp.hasMatch(idController.text) || !idPwdRegExp.hasMatch(pwdController.text)) {
        Get.snackbar(
          '회원가입 실패',
          '아이디와 비밀번호는 영어와 숫자만 입력 가능합니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 전화번호 유효성 검사
      String? phoneNumber = phoneNumberController.text;
      if (phoneNumber.length != 11) {
        Get.snackbar(
          '회원가입 실패',
          '전화번호는 11자리 숫자로, 010######## 형식을 지켜주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": idController.text,
          "password": pwdController.text,
          "user_name": nicknameController.text,
          "phone_number": phoneNumberController.text,
          "car_num": carNumberController.text,
          "car_model": carModelController.text,
          "user_type": userType,
        }),
      );

      if (response.statusCode == 200) {
        // 회원가입 성공 처리
        Get.snackbar(
          '회원가입 성공',
          '회원가입이 완료되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/login');
      } else if (response.statusCode == 409) {
        String bodyUtf8 = utf8.decode(response.bodyBytes);
        var responseJson = json.decode(bodyUtf8);
        String detailMessage = responseJson['detail'];
        Get.snackbar(
          '회원가입 실패',
          detailMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // 회원가입 실패 처리
        Get.snackbar(
          '회원가입 실패',
          '회원가입에 실패했습니다. 코드: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '서버 연결에 실패했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    idController.dispose();
    pwdController.dispose();
    pwdCheckController.dispose();
    nicknameController.dispose();
    phoneNumberController.dispose();
    carNumberController.dispose();
    carModelController.dispose();
    super.onClose();
  }
}
