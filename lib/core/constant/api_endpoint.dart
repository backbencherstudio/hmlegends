class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://constant-bull-individuals-paradise.trycloudflare.com';
  static const String googleLogin = 'http://192.168.5.232:4050/api/auth/google/signin';

  // Admin
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String forgetPassword = '/api/auth/forgot-password';
  static const String verify_otp = '/api/auth/reset-password';
  static const String setNewPassword = '/api/auth/reset-password';


  //Branch


  //Driver


  // static const String getBanners = '/api/getBanners';
  // static const String getProducts = '/api/products';
  // static const String getUsers = '/api/users';
}