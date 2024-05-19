class Task {
  final String id;
  final String name;
  final DateTime createdAt;
  final String? location;

  const Task ({
    required this.id,
    required this.name,
    required this.createdAt,
    this.location,
  });
}