class PostModel {
  final String title;
  final String description;
  final String data;

  const PostModel({
    required this.title,
    required this.description,
    required this.data,
  });

  static PostModel fromJson(json) => PostModel(
        title: json['title'],
        description: json['description'],
        data: json['data'],
      );
}
