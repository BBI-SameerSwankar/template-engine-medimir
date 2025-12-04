import 'carousel_tile/carousel_tile.dart';

class HomeScreenModel {
  final String id;
  final String title;
  final String layoutType;
  final String templateId;
  final List<CarouselTile> tiles;
  final int position;

  HomeScreenModel({
    required this.id,
    required this.title,
    required this.layoutType,
    required this.templateId,
    required this.tiles,
    required this.position,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      id: json['id'].toString(),
      title: (json['title'] ?? '') as String,
      layoutType: (json['layout_type'] ?? '') as String,
      templateId: (json['templateId'] ?? '') as String,
      tiles: (json['tiles'] as List<dynamic>? ?? [])
          .map((e) => CarouselTile.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      position: (json['position'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'layout_type': layoutType,
      'templateId': templateId,
      'tiles': tiles.map((t) => t.toJson()).toList(),
      'position': position,
    };
  }
}

class HomeScreenModelFactory {
  static List<HomeScreenModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (e) => HomeScreenModel.fromJson(
            (e as Map).cast<String, dynamic>(),
          ),
        )
        .toList();
  }
}
