class AppUser {
  final String id;
  final String name;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  AppUser copyWith({String? id, String? name, DateTime? createdAt}) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
