class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://creative-wanted-clause-trainers.trycloudflare.com';
  static const String googleLogin =
      'http://192.168.5.232:4050/api/auth/google/signin';

  // Admin
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String forgetPassword = '$baseUrl/api/auth/forgot-password';
  static const String verifyOtpOnly = '$baseUrl/api/auth/verify-reset-token';
  static const String setNewPassword = '$baseUrl/api/auth/reset-password';
  static const String adminProfileUpdate = '$baseUrl/api/auth/update';
  static const String adminCheckMe = '$baseUrl/api/auth/me';

  //Branch

  //Driver

  // static const String getBanners = '/api/getBanners';
  // static const String getProducts = '/api/products';
  // static const String getUsers = '/api/users';
}
