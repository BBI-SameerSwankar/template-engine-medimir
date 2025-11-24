import 'carousel_border.dart';
import 'carousel_image.dart';
import 'carousel_text.dart';
import 'carousel_tile_click_action.dart';


class CarouselTile {
  final List<CarouselText> texts;
  final List<CarouselImage> images;
  final List<CarouselBorder> border;
  final TileClickAction onClick;

  CarouselTile({
    required this.texts,
    required this.images,
    required this.border,
    required this.onClick,
  });

  factory CarouselTile.fromJson(Map<String, dynamic> json) {
    return CarouselTile(
      texts: (json['texts'] as List<dynamic>? ?? [])
          .map((e) => CarouselText.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => CarouselImage.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      border: (json['border'] as List<dynamic>? ?? [])
          .map((e) => CarouselBorder.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      onClick: TileClickAction.fromJson(
        (json['onClick'] ?? {}) as Map<String, dynamic>,
      ),
    );
  }
}