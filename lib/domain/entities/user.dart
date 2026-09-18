// Now used only for the admin account, since student self-login has been
// removed - students are managed as a separate directory (see Student
// entity) rather than having their own login accounts.
class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});
}
