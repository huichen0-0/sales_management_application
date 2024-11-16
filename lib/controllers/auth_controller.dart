import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:sales_management_application/models/Users.dart';

class AuthController extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Đăng ký người dùng
  Future<bool> register(String email, String fullName, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      //Gửi email xác thực
      await userCredential.user!.sendEmailVerification();

      if (user != null) {
        Users newUser = Users(
          uid: user.uid,
          accountCreationDate: DateTime.now(),
          age: null,
          fullName: fullName,
          email: email,
        );

        // Lưu thông tin vào Realtime Database
        await _database.child('User').child(user.uid).set(newUser.toJson());
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi khi đăng ký: $e');
      return false;
    }
  }

  //Đăng nhập
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!.emailVerified){
        _isLoggedIn = true;
        notifyListeners(); // Thông báo để cập nhật UI
      }
      return userCredential.user;
    } catch (e) {
      print('Lỗi khi đăng nhập: $e');
      return null;
    }
  }

  //Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
    _isLoggedIn = false;
    notifyListeners(); // Thông báo để cập nhật UI
  }

  //Quên mật khẩu
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Đổi mật khẩu
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Đăng nhập tạm thời để xác thực mật khẩu hiện tại
        await _auth.signInWithEmailAndPassword(email: user.email!, password: currentPassword);
        // Đổi mật khẩu
        await user.updatePassword(newPassword);
        return true;
      } catch (e) {
        return false; // Đổi mật khẩu thất bại
      }
    }
    return false; // Người dùng không tồn tại
  }
}