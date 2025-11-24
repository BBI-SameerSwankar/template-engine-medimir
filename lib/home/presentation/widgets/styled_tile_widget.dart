import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../template_engine/models/home_screen/carousel_tile/carousel_image.dart';
import '../template_engine/models/home_screen/carousel_tile/carousel_text.dart';
import '../template_engine/models/home_screen/carousel_tile/carousel_tile_click_action.dart';
import '../template_engine/models/home_screen/carousel_tile/extra_parameters.dart';
import '../template_engine/models/template_design/styled_carousel_tile.dart';
import '../template_engine/models/template_design/template_design_model/device_dimension.dart';
import '../template_engine/models/template_design/template_design_model/template_text.dart';
import '../template_engine/models/template_design/template_design_model/template_image.dart';
import '../template_engine/models/template_design/template_design_model/template_border.dart';

class StyledTileWidget extends StatelessWidget {
  final StyedCarouselTile styledTile;

  const StyledTileWidget({
    super.key,
    required this.styledTile,
  });

  CarouselText? _findText(String id) {
    for (final t in styledTile.tile.texts) {
      if (t.id == id) return t;
    }
    return null;
  }

  CarouselImage? _findImage(String id) {
    for (final img in styledTile.tile.images) {
      if (img.id == id) return img;
    }
    return null;
  }

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

  Color _parseHexColor(String hex, {Color fallback = Colors.transparent}) {
    if (hex.isEmpty) return fallback;
    var clean = hex.toUpperCase().replaceAll('#', '');
    if (clean.length == 6) clean = 'FF$clean';
    return Color(int.parse(clean, radix: 16));
    }

  FontWeight _mapFontWeight(String? w) {
    if (w == null) return FontWeight.w600; // your old default
    final upper = w.toUpperCase();
    if (upper.contains('BOLD')) return FontWeight.w700;
    if (upper.contains('MEDIUM')) return FontWeight.w500;
    if (upper.contains('LIGHT')) return FontWeight.w300;
    return FontWeight.w400;
  }

  void _handleClick(BuildContext context, TileClickAction action) {
    final ExtraParameters params = action.extraParameters;
    final buffer = StringBuffer()
      ..writeln('clickId: ${action.clickId}')
      ..writeln('toolId: ${params.toolId}')
      ..writeln('medicalAreaId: ${params.medicalAreaId}')
      ..writeln('newsId: ${params.newsId}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(buffer.toString()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Applies template borders to the tile container.
  Border _buildBorder(BuildContext context) {
    final borders = styledTile.template.borders;
    if (borders.isEmpty) return Border.all(color: Colors.transparent, width: 0);

    BorderSide sideFor(TemplateBorderConfig cfg) {
      final thickness = _resolveDimension(context, cfg.thickness);
      final color = _parseHexColor(cfg.color ?? "", fallback: Colors.transparent);
      return BorderSide(color: color, width: thickness.toDouble());
    }

    return Border(
      top: borders['top'] != null ? sideFor(borders['top']!) : BorderSide.none,
      bottom: borders['bottom'] != null ? sideFor(borders['bottom']!) : BorderSide.none,
      left: borders['left'] != null ? sideFor(borders['left']!) : BorderSide.none,
      right: borders['right'] != null ? sideFor(borders['right']!) : BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final template = styledTile.template;
    final tile = styledTile.tile;

    final resolvedWidth = template.width != null
        ? _resolveDimension(context, template.width!)
        : 260.0;
    final resolvedHeight = template.height != null
        ? _resolveDimension(context, template.height!)
        : 140.0;

    final tileWidth = math.max(80.0, resolvedWidth);
    final tileHeight = math.max(60.0, resolvedHeight);

    final children = <Widget>[];

    // ----- Texts -----
    for (final TemplateTextConfig textConfig in template.texts) {
      final textModel = _findText(textConfig.id);
      if (textModel == null) continue;

      final fontSize = textConfig.fontSize != null
          ? _resolveDimension(context, textConfig.fontSize!)
          : 14.0;

      final textBoxWidth = textConfig.width != null
          ? _resolveDimension(context, textConfig.width!)
          : (tileWidth - textConfig.xPoint - 8);

      final textBoxHeight = textConfig.height != null
          ? _resolveDimension(context, textConfig.height!)
          : null;

      // margin offsets
      final marginLeft = textConfig.margin != null
          ? _resolveDimension(context, textConfig.margin!.left)
          : 0.0;
      final marginTop = textConfig.margin != null
          ? _resolveDimension(context, textConfig.margin!.top)
          : 0.0;

      // padding inside text container
      final padLeft = textConfig.padding != null
          ? _resolveDimension(context, textConfig.padding!.left)
          : 0.0;
      final padRight = textConfig.padding != null
          ? _resolveDimension(context, textConfig.padding!.right)
          : 0.0;
      final padTop = textConfig.padding != null
          ? _resolveDimension(context, textConfig.padding!.top)
          : 0.0;
      final padBottom = textConfig.padding != null
          ? _resolveDimension(context, textConfig.padding!.bottom)
          : 0.0;

      final bgColor = _parseHexColor(textModel.textBg);
      final decoBg = _parseHexColor(textModel.decorationBg);

      Widget textChild = Text(
        textModel.text,
        maxLines: textConfig.maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: _mapFontWeight(textConfig.fontWeight),
          color: _parseHexColor(textModel.color, fallback: Colors.black),
          height: 1.2, // mild control to avoid crowding
        ),
      );

      // decoration wrapper (if JSON says borderRadius true)
      if (textConfig.decoration.borderRadius) {
        textChild = Container(
          decoration: BoxDecoration(
            color: decoBg == Colors.transparent ? bgColor : decoBg,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.fromLTRB(padLeft, padTop, padRight, padBottom),
          child: textChild,
        );
      } else if (padLeft + padTop + padRight + padBottom > 0) {
        textChild = Padding(
          padding: EdgeInsets.fromLTRB(padLeft, padTop, padRight, padBottom),
          child: textChild,
        );
      }

      children.add(
        Positioned(
          left: textConfig.xPoint.toDouble() + marginLeft,
          top: textConfig.yPoint.toDouble() + marginTop,
          child: SizedBox(
            width: math.max(0.0, textBoxWidth),
            height: textBoxHeight != null ? math.max(0.0, textBoxHeight) : null,
            child: textChild,
          ),
        ),
      );
    }

    // ----- Images -----
    for (final TemplateImageConfig imageConfig in template.images) {
      final imageModel = _findImage(imageConfig.id);
      if (imageModel == null) continue;

      final imgWidth = imageConfig.width != null
          ? _resolveDimension(context, imageConfig.width!)
          : 40.0;
      final imgHeight = imageConfig.height != null
          ? _resolveDimension(context, imageConfig.height!)
          : 40.0;

      // margin offsets for images
      final marginLeft = imageConfig.margin != null
          ? _resolveDimension(context, imageConfig.margin!.left)
          : 0.0;
      final marginTop = imageConfig.margin != null
          ? _resolveDimension(context, imageConfig.margin!.top)
          : 0.0;

      children.add(
        Positioned(
          left: imageConfig.xPoint.toDouble() + marginLeft,
          top: imageConfig.yPoint.toDouble() + marginTop,
          child: SizedBox(
            width: imgWidth,
            height: imgHeight,
            child: Image.network(
              imageModel.path,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
        ),
      );
    }

    final border = _buildBorder(context);

    return GestureDetector(
      onTap: () => _handleClick(context, tile.onClick),
      child: Container(
        width: tileWidth,
        height: tileHeight,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: border,
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: children,
        ),
      ),
    );
  }
}
