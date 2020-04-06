
import 'package:time_keeper/services/auth.dart';

class FormValidation {

  static AuthService _auth = AuthService();

  /// Handles an email login and it's validation
  /// 
  /// 0 - Login successful
  /// 
  /// 1 - Account doesn't exist
  /// 
  /// 2 - Email string is not properly formatted
  /// 
  /// 3 - Password isn't long enough (Must be 6 characters minimum)
  static Future<int> validateEmailLogin(String email, String password) async {

    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
    var user = await _auth.emailLogin(email, password);

    if (!emailValid) {
      return 2;
    } else if (password.length < 6) {
      return 3;
    } else if (user == null) {
      return 1;
    } else {
      return 0;
    }
  }

  /// Handles an email registration attempt and it's validation
  /// 
  /// 0 - Login successful
  /// 
  /// 1 - Account already exists
  /// 
  /// 2 - Email string is not properly formatted
  /// 
  /// 3 - Password isn't long enough (Must be 6 characters minimum)
  static Future<int> validateEmailRegistration(String email, String password) async {

    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
    var user = await _auth.emailRegister(email, password);

    if (!emailValid) {
      return 2;
    } else if (password.length < 6) {
      return 3;
    } else if (user == null) {
      return 1;
    } else {
      return 0;
    }
  }

}