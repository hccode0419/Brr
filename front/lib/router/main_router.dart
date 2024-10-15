import 'package:brr/view/driver_page/driver_callstart_page_view.dart';
import 'package:brr/view/location_write_page/location_write_page_view.dart';
import 'package:brr/view/history_page/history_page_view.dart';
import 'package:brr/view/matching_page/reservation_matching_view_page.dart';
import 'package:brr/view/mypage_page/mydata_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brr/view/main_page/main_page_view.dart';
import 'package:brr/view/match_list_page/match_list_view.dart';
import 'package:brr/layout/main_layout.dart';
import 'package:brr/layout/driver_main_layout.dart';
import 'package:brr/view/mypage_page/mypage_page_view.dart';
import 'package:brr/view/schedule_page/schedule_page_view.dart';
import 'package:brr/view/matching_page/fast_matching_view_page.dart';
import 'package:brr/view/sign_up_page/sign_up_view.dart';
import 'package:brr/view/login_page/login_page_view.dart';
import 'package:brr/view/driver_page/driver_main_page_view.dart';
import 'package:brr/view/mypage_page/mydata_page_view.dart';
import 'package:brr/view/history_page/history_page_view.dart';
import 'package:brr/view/loading_page/match_loading_page_view.dart';
import 'package:brr/view/location_write_page/location_write_page_view.dart';
import 'package:brr/view/loading_page/join_loading_page_view.dart';
import 'package:brr/view/loading_page/taxi_loading_page_view.dart';
import 'package:brr/view/matching_page/complete_matching_view_page.dart';
import 'package:brr/view/history_page/detail_history_page_view.dart';
import 'package:brr/view/driver_page/driver_work_page.dart';
import 'package:brr/view/chating_page/chating_page_view.dart';
import 'package:brr/view/driver_page/driver_accept_page_view.dart';
import 'package:brr/view/driver_page/driver_mypage_view.dart';
import 'package:brr/view/driver_page/driver_callstart_page_view.dart';
import 'package:brr/view/driver_page/driver_decide_navigation_page_view.dart';
import 'package:brr/view/driver_page/driver_complete_view.dart';
import 'package:brr/view/ride_complete_view.dart/ride_complete_view.dart';
import 'package:brr/view/driver_page/dirver_mydata_page_view.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const MainLayout(
        child: MainPageView(),
      ),
    ),
    GetPage(
      name: '/matchlist',
      page: () => const MainLayout(
        child: MatchinglistPageView(),
      ),
    ),
    GetPage(
      name: '/mypage',
      page: () => MainLayout(
        child: MypagePageView(),
      ),
    ),
    GetPage(
      name: '/schedule',
      page: () => const MainLayout(
        child: SchedulePageView(),
      ),
    ),
    GetPage(
      name: '/matching',
      page: () => const MainLayout(
        child: MatchingPageView(),
      ),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginPageView(),
    ),
    GetPage(
      name: '/signup',
      page: () => const SignUpPageView(),
    ),
    GetPage(
      name: '/mydata',
      page: () => const MainLayout(
        child: MyDataPageView(),
      ),
    ),
    GetPage(
      name: '/history',
      page: () => const MainLayout(
        child: HistoryPageView(),
      ),
    ),
    GetPage(
      name: '/matchloading',
      page: () => const MainLayout(
        child: MatchLoadingPageView(),
      ),
    ),
    GetPage(
      name: '/writelocation',
      page: () => const MainLayout(
        child: WriteLocationPageView(),
      ),
    ),
    GetPage(
      name: '/joinloading',
      page: () => const MainLayout(
        child: JoinMatchLoadingPageView(),
      ),
    ),
    GetPage(
      name: '/taxiloading',
      page: () => const MainLayout(
        child: TaxiLoadingPageView(),
      ),
    ),
    GetPage(
      name: '/completematching',
      page: () => const MainLayout(
        child: CompleteMatchingViewPage(),
      ),
    ),
    GetPage(
      name: '/detailhistory',
      page: () => const MainLayout(
        child: DetailHistoryPageView(),
      ),
    ),
    GetPage(
      name: '/drivermain',
      page: () => const DriverMainLayout(
        child: DriverMainPageView(),
      ),
    ),
    GetPage(
      name: '/driverwork',
      page: () => DriverMainLayout(
        child: DriverWorkPageView(),
      ),
    ),
    GetPage(
        name: '/reservation',
        page: () => const MainLayout(child: ReservationMatchingPageView())),
    GetPage(
      name: '/chating',
      page: () => MainLayout(
        child: ChatingPageView(
          taxiId: Get.arguments, 
        ),
      ),
    ),
    GetPage(
        name: '/driveraccept',
        page: () => DriverMainLayout(
              child: CallAcceptPageView(
                matchingId: Get.arguments['matching_id'],
              ),
            )),
    GetPage(
      name: '/drivermypage',
      page: () => const DriverMainLayout(
        child: DriverMypageView(),
      ),
    ),
    GetPage(
        name: '/callstart',
        page: () => const DriverMainLayout(
              child: DriverCallstartPageView(),
            )),
    GetPage(
        name: '/decidenavigation',
        page: () => DriverMainLayout(
              child: DriverDecideNavigationPageView(
                matchingId: Get.arguments,
              ),
            )),
    GetPage(
        name: '/drivercomplete',
        page: () => DriverMainLayout(
              child: DriverCompletePageView(
                matchingId: Get.arguments['matchingId'],
                fare: Get.arguments['fare'],
              ),
            )),
    GetPage(
      name: '/ridecomplete',
      page: () => const MainLayout(
        child: RideCompletePageView(),
      ),
    ),
    GetPage(
      name: '/driverdata',
      page: () => const DriverMainLayout(
        child: DriverDataPageView(),
      ),
    ),
  ];
}
