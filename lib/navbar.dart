import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localpro/home.dart';

import 'package:localpro/profile.dart';
import 'package:localpro/search.dart';

class NavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final List<Widget> pages = [
    Home(),
    SearchPage(),
    UserProfilePage(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.put(NavController());
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navController.currentIndex.value,
            children: navController.pages,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changePage,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            /*   BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'), */
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
