String? currentUserEmail;
final List<Map<String, String>> fakeUsers = [];

bool registerUser(String email, String password) {
  if (fakeUsers.any((u) => u['email'] == email)) return false;
  fakeUsers.add({'email': email, 'password': password});
  return true;
}

bool loginUser(String email, String password) {
  final user = fakeUsers.firstWhere(
    (u) => u['email'] == email && u['password'] == password,
    orElse: () => {},
  );
  if (user.isEmpty) return false;
  currentUserEmail = email;
  return true;
}

void logoutUser() {
  currentUserEmail = null;
}
