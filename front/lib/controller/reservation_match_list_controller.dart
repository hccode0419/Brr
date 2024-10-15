import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/model/reservation_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brr/constants/url.dart';
import 'dart:io';
import 'dart:async';

class ReservationMatchController extends GetxController {
  var ReservationMatches = <ReservationMatch>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReservationMatches();
  }

  void fetchReservationMatches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        Get.offAllNamed('/login');
        return;
      }

      final url = '${Urls.apiUrl}matching/lobbies/1/';
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final dynamic responseData = jsonDecode(responseBody);

        if (responseData is List) {
          // 응답이 리스트인 경우, 리스트의 각 항목을 ReservationMatch 객체로 변환
          ReservationMatches.value = responseData.map((match) => ReservationMatch.fromJson(match)).toList();
        } else if (responseData is Map<String, dynamic>) {
          // 응답이 단일 객체(Map)인 경우, ReservationMatch 객체로 변환 후 리스트에 추가
          ReservationMatch match = ReservationMatch.fromJson(responseData);
          ReservationMatches.value = [match];
        } else {
          throw Exception("Unexpected response format: ${responseData.runtimeType}");
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
      } else if (response.statusCode == 404) {
        Get.snackbar('Error', '데이터를 찾을 수 없습니다.', snackPosition: SnackPosition.BOTTOM);
      } else if (response.statusCode >= 500) {
        Get.snackbar('Error', '서버 오류가 발생했습니다. 나중에 다시 시도해주세요.', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', '알 수 없는 오류가 발생했습니다. 상태 코드: ${response.statusCode}', snackPosition: SnackPosition.BOTTOM);
      }
    } on SocketException {
      Get.snackbar('Error', '네트워크 연결을 확인해주세요.', snackPosition: SnackPosition.BOTTOM);
    } on TimeoutException {
      Get.snackbar('Error', '서버 응답 시간이 초과되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } on FormatException {
      Get.snackbar('Error', '잘못된 데이터 형식입니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print('오류: $e');
      Get.snackbar('Error', '예기치 않은 오류가 발생했습니다: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
