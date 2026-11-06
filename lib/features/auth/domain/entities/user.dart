class User {
  final String id;
  final String name;
  final String? email;
  
  User({
    required this.id,
    required this.name,
    this.email,
  });
}