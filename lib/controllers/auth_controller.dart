import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sales_management_application/models/Users.dart';

class AuthController extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FlutterSecureStorage _storage = FlutterSecureStorage(); //Biến hỗ trợ lưu trữ token

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
      if(userCredential.user!.emailVerified){//Nếu email người dùng đã xác nhận

        //Lấy access token của user
        String? accessToken = await userCredential.user!.getIdToken();
      
        // Lưu access token vào Secure Storage
        await _storage.write(key: 'access_token', value: accessToken);

        _isLoggedIn = true;
        notifyListeners(); // Thông báo để cập nhật UI
      }
      return userCredential.user;
    } catch (e) {
      print('Lỗi khi đăng nhập: $e');
      return null;
    }
  }

  //Kiểm tra xem có người dùng đang đăng nhập hay không và làm mới access token
  Future<void> checkAndRefreshToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Lấy access token mới
      String? newAccessToken = await user.getIdToken(true);
      await _storage.write(key: 'access_token', value: newAccessToken);
    }
  }

  //Kiểm tra lần cuối thoát khỏi ứng dụng đang đăng nhập hay đã đăng xuất
  Future<void> checkLogin() async {
    String? accessToken = await _storage.read(key: 'access_token');
    if (accessToken != null) { //Nếu access token vẫn được lưu
      checkAndRefreshToken();
      _isLoggedIn = true;
    } else { //Nếu đã xóa access token
      _isLoggedIn = false;
    }
    notifyListeners(); // Thông báo để cập nhật UI
  }

  //Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
    await _storage.delete(key: 'access_token'); //Xóa access token khỏi Secure Storage 
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

  // Lấy thông tin người dùng
  Future<Users?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _database.child('User').child(user.uid).get();
      if (snapshot.exists) {
        return Users.fromJson(snapshot.value as Map<dynamic, dynamic>);
      }
    }
    return null; // Trả về null nếu không tìm thấy người dùng
  }

}