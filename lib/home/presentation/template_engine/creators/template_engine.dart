import '../models/home_screen/home_screen_carousel.dart';
import '../models/template_design/template_design_model/template_design_model.dart';
import '../models/template_design/styled_carousel_tile.dart';

class TemplateEngine {
  /// Takes a carousel and its template, and merges them
  static List<StyedCarouselTile> buildTiles(
    HomeScreenModel carousel,
    TemplateDesignModel template,
  ) {
    return carousel.tiles
        .map(
          (tile) => StyedCarouselTile(
            tile: tile,
            template: template,
          ),
        )
        .toList();
  }
}
