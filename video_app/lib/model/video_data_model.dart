class VideoDataModel {
  final String name;
  final String videoUrl;
  final DateTime? creationDateTime;
  final int? size;
  VideoDataModel({
    required this.name,
    required this.videoUrl,
    required this.creationDateTime,
    required this.size,
  });

  VideoDataModel copyWith({
    String? name,
    String? videoUrl,
    DateTime? creationDateTime,
    int? size,
  }) {
    return VideoDataModel(
      name: name ?? this.name,
      videoUrl: videoUrl ?? this.videoUrl,
      creationDateTime: creationDateTime ?? this.creationDateTime,
      size: size ?? this.size,
    );
  }
}
