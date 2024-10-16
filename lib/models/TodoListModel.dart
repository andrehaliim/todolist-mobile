class TodoListModel {
  int id;
  String title;
  String text;

  TodoListModel({
    required this.id,
    required this.title,
    required this.text,
  });

  factory TodoListModel.fromJson(Map<String, dynamic> json) {
    return TodoListModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      text: json['text'] ?? '',
    );
  }

  factory TodoListModel.empty() {
    return TodoListModel(
      id: 0,
      title: '',
      text: '',
    );
  }
}