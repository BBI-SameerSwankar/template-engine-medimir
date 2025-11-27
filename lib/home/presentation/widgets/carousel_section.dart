import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../template_engine/creators/template_engine.dart';
import '../template_engine/models/home_screen/home_screen_carousel.dart';
import '../template_engine/models/template_design/template_design_model/template_design_model.dart';
import '../template_engine/models/template_design/template_design_model/device_dimension.dart';

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

  /// Resolve a DeviceDimension to a logical pixel value based on device/orientation.
  double _resolveDimension(BuildContext context, DeviceDimension dim) {
    final mq = MediaQuery.of(context);
    final orientation = mq.orientation;
    final shortestSide = mq.size.shortestSide;
    final isTablet = shortestSide >= 600;

    if (!isTablet && orientation == Orientation.portrait) {
      return dim.phonePortrait.toDouble();
    } else if (!isTablet && orientation == Orientation.landscape) {
      return dim.phoneLandscape.toDouble();
    } else if (isTablet && orientation == Orientation.portrait) {
      return (dim.tabPortrait ?? dim.phonePortrait).toDouble();
    } else {
      return (dim.tabLandscape ?? dim.phoneLandscape).toDouble();
    }
  }

  /// Height of one tile from the template; used as the height of the whole carousel row.
  double _tileHeightForSection(BuildContext context) {
    if (template == null || template!.height == null) {
      // fallback that still bounds the ListView vertically
      return 140.0;
    }
    final h = _resolveDimension(context, template!.height!);
    // avoid degenerate values
    return math.max(60.0, h);
  }

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (template != null) {
      final styledTiles = TemplateEngine.buildTiles(carousel, template!);

      // layout_type decides scrolling behaviour
      if (carousel.layoutType == 'scrolling') {
        final rowHeight = _tileHeightForSection(context);

        content = SizedBox(
          // height driven by template tile height
          height: rowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
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

    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.4,
        );

    final seeAllStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.blueAccent,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: section label + "See all"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              carousel.title.toUpperCase(),
              style: labelStyle,
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('See all: ${carousel.title}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('See all', style: seeAllStyle),
            ),
          ],
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}
