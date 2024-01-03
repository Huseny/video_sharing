class VideoModel {
  const VideoModel({
    required this.id,
    required this.videoUrl,
    required this.title,
    required this.author,
    required this.description,
    required this.createdAt,
    required this.thumbnailUrl,
  });

  final String id, videoUrl, title, description, thumbnailUrl, author;
  final DateTime createdAt;

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
        id: json['id'],
        videoUrl: json['videoUrl'],
        title: json['title'],
        author: json['author'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        thumbnailUrl: json["thumbnailUrl"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "videoUrl": videoUrl,
      "title": title,
      "author": author,
      "description": description,
      "createdAt": createdAt.toIso8601String(),
      "thumbnailUrl": thumbnailUrl
    };
  }
}
