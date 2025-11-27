class ApiEndpoints {
  ApiEndpoints._();

<<<<<<< HEAD
  static const String baseUrl = 'https://estimation-knowledge-holders-supporting.trycloudflare.com';
=======
  static const String baseUrl =
      'https://estimation-knowledge-holders-supporting.trycloudflare.com';
>>>>>>> 8d0e4b853c0f0e43be07c1dcaf949d0ecb792fca
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
  static const String adminStatus = '$baseUrl/api/auth/admin/stats';
  static const String adminAllProduct = '$baseUrl/api/product';
  static const String adminCreateProduct = '$baseUrl/api/product';
  static String updateProduct(String pid) => '$baseUrl/api/product/$pid';
  static String fetchSingleProduct(String pid) => '$baseUrl/api/product/$pid';
  static String deleteProduct(String pid) => '$baseUrl/api/product/$pid';
  static String adminOrder = '$baseUrl/api/order/admin';
  static String getAllInvoice = '$baseUrl/api/invoice';
  static String getInvoiceDetailAdmin(String orderId) =>
      '$baseUrl/api/invoice/order/$orderId';

  //Branch
  //static String getInvoices = '$baseUrl/api/invoice';
  static String getInvoiceDetail(String orderId) =>
      '$baseUrl/api/invoice/order/$orderId';
  static String getInvoices = '$baseUrl/api/invoice?search=manager';
  //static  String getInvoiceDetail(String orderId) => '$baseUrl/api/invoice/order/$orderId';
  //orders
<<<<<<< HEAD
  static  String getAllProducts = '$baseUrl/api/product';
  static  String placeOrder = '$baseUrl/api/order';
  static  String getMyOrders = '$baseUrl/api/order';
  // core/constant/api_endpoint.dart

  static String paymentPaid(String invoiceId) =>
  '$baseUrl/api/invoice/$invoiceId/pay';

  static const String avatarPath = "/storage/avatar";
=======
  static String getAllProducts = '$baseUrl/api/product';
  static String placeOrder = '$baseUrl/api/order';
>>>>>>> 8d0e4b853c0f0e43be07c1dcaf949d0ecb792fca

  //Driver

  static const String getAllDeliveryAdmin = '$baseUrl/api/delivery';
  static  String getSingleDeliveryDriver(String Id) => '$baseUrl/api/delivery/$Id';
  static  String deliveryReceivedAdmin(String Id) => '$baseUrl/api/delivery/$Id';
  static  String deliveryConfirmAdmin(String Id) => '$baseUrl/api/delivery/$Id';
  // static const String getProducts = '/api/products';
  // static const String getUsers = '/api/users';
}
