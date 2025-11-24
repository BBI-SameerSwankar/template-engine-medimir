import 'package:flutter/material.dart';

import '../template_engine/creators/template_engine.dart';
import '../template_engine/models/home_screen/home_screen_carousel.dart';
import '../template_engine/models/template_design/template_design_model/template_design_model.dart';

import 'fallback_tile.dart';
import 'styled_tile_widget.dart';

/// A single home section (e.g. "Top Tools Worldwide").
///
/// If a [template] is provided, tiles are rendered using the TemplateEngine.
/// Otherwise we fall back to a simple layout.
class CarouselSection extends StatelessWidget {
  final HomeScreenModel carousel;
  final TemplateDesignModel? template;

  const CarouselSection({
    super.key,
    required this.carousel,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (template != null) {
      final styledTiles = TemplateEngine.buildTiles(carousel, template!);

      // layout_type decides scrolling behaviour
      if (carousel.layoutType == 'scrolling') {
        content = SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: styledTiles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return StyledTileWidget(styledTile: styledTiles[index]);
            },
          ),
        );
      } else {
        content = Wrap(
          spacing: 12,
          runSpacing: 12,
          children: styledTiles
              .map(
                (t) => StyledTileWidget(styledTile: t),
              )
              .toList(),
        );
      }
    } else {
      // no template for this section yet -> simple fallback tiles
      content = Wrap(
        spacing: 12,
        runSpacing: 12,
        children: carousel.tiles
            .map(
              (tile) => FallbackTile(tile: tile),
            )
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          carousel.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}
