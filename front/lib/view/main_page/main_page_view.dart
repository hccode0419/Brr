import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/constants/bottom_navigation/bottom_navigation_controller.dart';
import 'package:brr/design_materials/design_materials.dart';
import 'package:brr/controller/join_match_controller.dart';
import 'package:brr/controller/quickmatch_list_controller.dart';
import 'package:brr/controller/location_controller.dart'; // 추가
import 'package:brr/util.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  final QuickMatchController quickMatchController =
      Get.put(QuickMatchController());
  final JoinMatchController joinMatchController =
      Get.put(JoinMatchController());
  final _bottomNavController = Get.put(MyBottomNavigationBarController());
  final LocationController locationController = Get.put(LocationController());

  String courseName = "";
  String startTime = "";
  String endTime = "";
  String location = "";

  @override
  void initState() {
    super.initState();
    fetchClosestSchedule();
  }

  Future<void> fetchClosestSchedule() async {
    Map<String, dynamic>? closestSchedule = await getNextSchedule();
    setState(() {
      courseName = closestSchedule['lecture'] ?? '예정된 수업 없음';
      startTime = closestSchedule['startTime'];
      endTime = closestSchedule['endTime'];
      location = closestSchedule['location'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            leading: const SizedBox(),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 25.0),
              title: Align(
                alignment: Alignment.centerLeft,
                child: brrLogo(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 10),
                  buildContainer(
                    height: 150,
                    color: const Color(0xFF1479FF),
                    sidecolor: const Color(0xFF1479FF),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "택시 매칭하기",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildElevatedButton(
                                "빠른 매칭", Icons.link, '/matching'),
                            const SizedBox(width: 10),
                            buildElevatedButton(
                                "매칭 예약", Icons.alarm, '/reservation'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildContainer(
                    height: 200,
                    color: const Color(0xFFF3F8FF),
                    sidecolor: const Color(0xFFE2EAF5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        title_custom("예약목록", "자세히보기", "/mainpage"),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2EAF5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      locationRow_reser(
                                          circleContainer, "출발지", "부산대정문"),
                                      const SizedBox(height: 5),
                                      locationRow_reser(
                                          rectangularContainer, "도착지", "부산대역"),
                                    ],
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("12시 탑승 예정",
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                      Text("3/4",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '1시간 30분 뒤 출발',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  buildContainer(
                    color: const Color(0xFFF3F8FF),
                    sidecolor: const Color(0xFFE2EAF5),
                    height: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        title_custom("목적지 추천", "목적지를 이곳으로 선택", '/matching'),
                        if (courseName == '다음 수업이 없습니다.')
                          const Column(
                            children: [
                              SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "다음 수업이 없습니다.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        else
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 36,
                                        color: const Color(0xFF1479FF),
                                      ),
                                      const SizedBox(width: 4),
                                      Column(
                                        children: [
                                          Text(
                                            courseName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "$startTime ~ $endTime, $location",
                                            style: const TextStyle(
                                              fontSize: 8,
                                              color: Color.fromARGB(
                                                  255, 153, 153, 153),
                                            ),
                                          ),
                                          Text(
                                            getTimeDifferenceString(startTime),
                                            style: const TextStyle(
                                              fontSize: 8,
                                              color: Color.fromARGB(
                                                  255, 153, 153, 153),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        locationController.endLocation.value = location;
                                        Get.toNamed('/matching');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xFF1479FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.location_on,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        location,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.visible,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  buildContainer(
                    color: const Color(0xFFF3F8FF),
                    sidecolor: const Color(0xFFE2EAF5),
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        title_custom("매칭 목록", "더보기", "/matchlist"),
                        Obx(() {
                          if (quickMatchController.quickMatches.isEmpty) {
                            return const Center(child: Text("빠른 매칭이 없습니다."));
                          }
                          int itemCount =
                              quickMatchController.quickMatches.length < 3
                                  ? quickMatchController.quickMatches.length
                                  : 3;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              int reverseIndex =
                                  quickMatchController.quickMatches.length -
                                      index -
                                      1;
                              final quickMatch = quickMatchController
                                  .quickMatches[reverseIndex];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: ElevatedButton(
                                  style: buttonStyle(),
                                  onPressed: () {
                                    joinMatchController
                                        .joinMatch(quickMatch.id);
                                  },
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          locationRow(circleContainer, "출발지",
                                              quickMatch.depart),
                                          const SizedBox(height: 5.0),
                                          locationRow(rectangularContainer,
                                              "도착지", quickMatch.dest),
                                        ],
                                      ),
                                      const Spacer(),
                                      boardingInfo(quickMatch.boardingTime
                                          .toString()
                                          .substring(11, 16)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainer({
    required Widget child,
    double height = double.infinity,
    double width = double.infinity,
    required Color color,
    required Color sidecolor,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: sidecolor),
      ),
      child: child,
    );
  }

  Widget title_custom(String title, String buttonText, String destination) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (title == '매칭 목록')
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.find<QuickMatchController>().refreshQuickMatches();
                },
                icon: const Icon(Icons.refresh, size: 20, color: Colors.black),
              ),
            ],
          )
        else
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        TextButton(
          onPressed: () {
            locationController.endLocation.value = location;
            Get.toNamed(destination);
          },
          child: Text(
            "$buttonText >",
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildElevatedButton(String text, IconData icon, String destination) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.toNamed(destination);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon, size: 15),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}

Widget locationRow_reser(Widget icon, String label, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      icon,
      const SizedBox(width: 10.0),
      Text(
        label,
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF676767),
        ),
      ),
      const SizedBox(width: 10.0),
      Text(
        text,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}
