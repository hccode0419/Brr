import 'package:get/get.dart';
import 'package:brr/controller/location_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brr/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AddMatchListController extends GetxController {
  final LocationController locationController = Get.find<LocationController>();
  RxString currentMemberStatus = '1'.obs;
  RxInt selectedMinMember = 0.obs;
  late WebSocketChannel channel;
  RxInt lobbyId = 0.obs; // 로비 ID를 관리하는 변수
  RxBool isReservation = false.obs;
  Rx<DateTime> selectedDateTime = DateTime.now().obs;

  Future<void> sendMatchData(int minMember) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      Get.offAllNamed('/login');
      return;
    }

    final int matchingType = isReservation.value ? 1 : 0;

    String boardingTime;

    if (isReservation.value) {
      boardingTime = selectedDateTime.toString(); // 예약 매칭의 경우 사용자가 선택한 시간
    } else {
      boardingTime = DateTime.now().toString(); // 빠른 매칭의 경우 현재 시간
    }

    final startLocation = locationController.startLocation.value;
    final endLocation = locationController.endLocation.value;
    final taxi_fare = locationController.taxiFare.value;
    final distance = (locationController.distance.value / 1000).round();
    final duration = (locationController.duration.value / 60000).round();
    final pathJson = locationController.convertPathToJson(locationController.pathCoordinates[0]);

    print("$distance , $duration, $taxi_fare, $pathJson");

    final data = {
      "matching_type": matchingType,
      "boarding_time": boardingTime,
      "depart": startLocation.isEmpty ? '' : startLocation,
      "dest": endLocation.isEmpty ? '' : endLocation,
      "min_member": minMember,
      "taxi_fare": taxi_fare,
      "distance": distance,
      "duration": duration,
      "path": pathJson  
    };

    final url = '${Urls.apiUrl}matching/create';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Match data sent successfully');

        // 매칭 데이터가 성공적으로 전송되면 WebSocket 연결 시작
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        lobbyId.value = responseData['id']; // 서버로부터 받은 lobby_id를 설정
        joinLobby(lobbyId.value);
      } else {
        print('Failed to send match data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending match data: $e');
    }
  }


  void joinLobby(int lobbyId) {
    final url = 'ws://${Urls.wsUrl}matching/lobbies/$lobbyId/ws';
    channel = WebSocketChannel.connect(Uri.parse(url));

    channel.stream.listen((message) {
      print("Received message: $message");
      currentMemberStatus.value = message;
      print("서버연결이 완료되었음");
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  Future<void> completeLobby() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      Get.offAllNamed('/login');
      return;
    }

    final url = '${Urls.apiUrl}matching/lobbies/complete';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: utf8.encode(json.encode({'id': lobbyId.value})),
      );

      if (response.statusCode == 200) {
        print('Lobby completed successfully'); // 성공 시 페이지 이동
      } else {
        print('Failed to complete lobby: ${response.statusCode}, ${lobbyId.value}');
        Get.snackbar('Error', '대기실 완료에 실패했습니다.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error occurred while completing lobby: $e');
      Get.snackbar('Error', '예기치 않은 오류가 발생했습니다.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void disconnectFromLobby() {
    channel.sink.close();
  }

  @override
  void onClose() {
    disconnectFromLobby(); // 컨트롤러가 닫힐 때 WebSocket 연결 해제
    super.onClose();
  }
}
