class CarouselImage {
  final String path;
  final String id;
  final String color;

  CarouselImage({
    required this.path,
    required this.id,
    required this.color,
  });

  factory CarouselImage.fromJson(Map<String, dynamic> json) {
    return CarouselImage(
      path: (json['path'] ?? '') as String,
      id: (json['id'] ?? '') as String,
      color: (json['color'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'id': id,
      'color': color,
    };
  }
}
