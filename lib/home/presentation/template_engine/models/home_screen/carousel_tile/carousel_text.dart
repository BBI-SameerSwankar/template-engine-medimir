class CarouselText {
  final String text;
  final String id;
  final String color;
  final String textBg;
  final String decorationBg;

  CarouselText({
    required this.text,
    required this.id,
    required this.color,
    required this.textBg,
    required this.decorationBg,
  });

  factory CarouselText.fromJson(Map<String, dynamic> json) {
    return CarouselText(
      text: (json['text'] ?? '') as String,
      id: (json['id'] ?? '') as String,
      color: (json['color'] ?? '') as String,
      textBg: (json['textbg'] ?? '') as String,
      decorationBg: (json['decorationbg'] ?? '') as String,
    );
  }
}