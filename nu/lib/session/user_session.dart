class UserSession {
  static String? userId;
  static String? fullName;
  static String? email;
  static String? phoneNumber;
  static String? role;

  static void setUser({
    required String id,
    required String name,
    required String userEmail,
    required String userPhone,
    required String userRole,
  }) {
    userId = id;
    fullName = name;
    email = userEmail;
    phoneNumber = userPhone;
    role = userRole;
  }

  static void clear() {
    userId = null;
    fullName = null;
    email = null;
    phoneNumber = null;
    role = null;
  }
}