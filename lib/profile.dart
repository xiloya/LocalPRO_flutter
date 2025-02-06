import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var selectedTabIndex = 0.obs;
  final String userEmail = 'johndoe@gmail.com';
  final String userName = 'John Doe';
  var messages = <String>[].obs;

  void changeTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  void editProfile() => Get.snackbar('Edit Profile', 'Edit profile clicked');
  void openSettings() => Get.snackbar('Settings', 'Settings clicked');
  void logout() {
    Get.snackbar('Logout', 'Logging out... (Dummy)');
    Get.offAllNamed('/home');
  }
}

class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});
  final ProfileController _controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileTabBar(controller: _controller),
                  Obx(() => _controller.selectedTabIndex.value == 0
                      ? Column(
                          children: const [
                            UserInfoSection(),
                            ProfileActions(),
                          ],
                        )
                      : const MessagesSection()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.blue,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          const Expanded(
            child: Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFA1CEFF),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Montserrat',
                  color: const Color(0xFF6F7787),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'johndoe@gmail.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF565D6D),
                ),
          ),
        ],
      ),
    );
  }
}

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildActionButton(
            context,
            icon: Icons.edit,
            label: 'Edit Profile',
            onPressed: () => Get.find<ProfileController>().editProfile(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.settings,
            label: 'Settings',
            onPressed: () => Get.find<ProfileController>().openSettings(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.logout,
            label: 'Logout',
            isPrimary: false,
            onPressed: () => Get.find<ProfileController>().logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF0056B3) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF565D6D),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isPrimary ? Colors.transparent : const Color(0xFFBDC1CA),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class ProfileTabBar extends StatelessWidget {
  final ProfileController controller;
  const ProfileTabBar({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Obx(
        () => Row(
          children: [
            _buildTabButton('Home', 0),
            _buildTabButton('Messages', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTabIndex(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: controller.selectedTabIndex.value == index
                    ? const Color(0xFF0056B3)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: controller.selectedTabIndex.value == index
                  ? const Color(0xFF0056B3)
                  : const Color(0xFF565D6D),
              fontWeight: controller.selectedTabIndex.value == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class MessagesSection extends StatelessWidget {
  const MessagesSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var messages = Get.find<ProfileController>().messages;
      return messages.isEmpty
          ? const Center(child: Text('No messages yet.'))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(messages[index]),
              ),
            );
    });
  }
}
