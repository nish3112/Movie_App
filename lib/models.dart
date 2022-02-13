class todo {
  final int id;
  final String title;
  final String description;
  final String photo;

  todo({
    required this.id,
    required this.title,
    required this.description,
    required this.photo
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photo' : photo
    };
  }

  todo.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
        photo = res['photo'];

  @override
  String toString() {
    return 'todo{id: $id, title: $title, description: $description, photo: $photo}';
  }
}