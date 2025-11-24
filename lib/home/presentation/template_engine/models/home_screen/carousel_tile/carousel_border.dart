class CarouselBorder {
  final String id;
  final String color;

  CarouselBorder({
    required this.id,
    required this.color,
  });

  factory CarouselBorder.fromJson(Map<String, dynamic> json) {
    return CarouselBorder(
      id: (json['id'] ?? '') as String,
      color: (json['color'] ?? '') as String,
    );
  }
}