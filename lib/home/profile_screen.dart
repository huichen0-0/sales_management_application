import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sales_management_application/authentication/auth_controller.dart';
import 'package:sales_management_application/authentication/users.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Hồ sơ', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Profile Picture
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: Text(
                  '?',
                  style: TextStyle(color: Colors.white, fontSize: 70),
                ),
              ),
              const SizedBox(height: 20),
              // User Information
              FutureBuilder<Users?>(
                future: authController.getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  }
                  final user = snapshot.data;
                  return Column(
                    children: [
                      Text(
                        user?.fullName ?? 'Tên người dùng',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? 'email@example.com',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              // Profile Actions
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.blue),
                      title: const Text('Chỉnh sửa hồ sơ'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate to edit profile screen
                        context.push('/editProfile');
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading:
                          const Icon(Icons.lock_outline, color: Colors.blue),
                      title: const Text('Đổi mật khẩu'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate to change password screen
                        context.push('/resetPassword');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authController.logout();
                    context.go('/'); // Navigate to login screen
                  },
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  label: const Text('Đăng xuất',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
