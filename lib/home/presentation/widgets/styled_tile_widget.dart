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

  const StyledTileWidget({super.key, required this.styledTile});

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
    try {
      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  FontWeight _mapFontWeight(String? w) {
    if (w == null) return FontWeight.w400;
    final upper = w.toUpperCase();

    if (upper.contains('BOLD')) return FontWeight.w700;
    if (upper.contains('MEDIUM')) return FontWeight.w500;
    if (upper.contains('LIGHT')) return FontWeight.w300;
    return FontWeight.w400; // NORMAL / default
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

  // Uses template borders (top/left/right/bottom) to draw the card outline.
  Border _buildBorder(BuildContext context) {
    final borders = styledTile.template.borders;
    if (borders.isEmpty) {
      // Default to a light grey outline.
      return Border.all(color: Colors.grey.shade300, width: 1);
    }

    BorderSide sideFor(TemplateBorderConfig cfg) {
      final thickness = _resolveDimension(context, cfg.thickness);
      final color = _parseHexColor(
        cfg.color ?? "",
        fallback: Colors.grey.shade300,
      );
      return BorderSide(color: color, width: thickness.toDouble());
    }

    return Border(
      top: borders['top'] != null ? sideFor(borders['top']!) : BorderSide.none,
      bottom: borders['bottom'] != null
          ? sideFor(borders['bottom']!)
          : BorderSide.none,
      left: borders['left'] != null
          ? sideFor(borders['left']!)
          : BorderSide.none,
      right: borders['right'] != null
          ? sideFor(borders['right']!)
          : BorderSide.none,
    );
  }

  TextAlign _mapTextAlign(String? raw) {
    if (raw == null) return TextAlign.start;
    final v = raw.toString().toUpperCase();

    if (v == 'CENTER') return TextAlign.center;
    if (v == 'RIGHT' || v == 'END') return TextAlign.end;
    if (v == 'LEFT' || v == 'START') return TextAlign.start;

    return TextAlign.start;
  }

  @override
  Widget build(BuildContext context) {
    final template = styledTile.template;
    final tile = styledTile.tile;

    // Card dimensions from template JSON
    final resolvedWidth = template.width != null
        ? _resolveDimension(context, template.width!)
        : 260.0;
    final resolvedHeight = template.height != null
        ? _resolveDimension(context, template.height!)
        : 140.0;

    final tileWidth = math.max(80.0, resolvedWidth);
    final tileHeight = math.max(60.0, resolvedHeight);

    final children = <Widget>[];

    // ----- TEXTS -----
    for (final TemplateTextConfig textConfig in template.texts) {
      final textModel = _findText(textConfig.id);
      if (textModel == null) continue;

      final fontSize = _resolveDimension(context, textConfig.fontSize);

      final textBoxWidth = _resolveDimension(context, textConfig.width);
      final rawHeight = _resolveDimension(context, textConfig.height);
      final textBoxHeight = rawHeight <= 0 ? null : rawHeight;

      final marginLeft = _resolveDimension(context, textConfig.margin.left);
      final marginTop = _resolveDimension(context, textConfig.margin.top);

      final padLeft = _resolveDimension(context, textConfig.padding.left);
      final padRight = _resolveDimension(context, textConfig.padding.right);
      final padTop = _resolveDimension(context, textConfig.padding.top);
      final padBottom = _resolveDimension(context, textConfig.padding.bottom);

      // Colors from data:
      // textbg -> fill color of the pill/tag
      // decorationbg -> border color of the pill/tag
      final fillColor = _parseHexColor(textModel.textBg);        // textbg
      final decoColor = _parseHexColor(textModel.decorationBg);  // decorationbg

      final deco = textConfig.decoration;
      // Ensure your model makes this an int, not bool.
      final radius = (deco?.borderRadius ?? 0).toDouble();

      // Base text widget
      Widget textChild = Text(
        textModel.text,
        softWrap: true,
        maxLines: textConfig.maxLines, // assuming your model has this; if not, set to null
        overflow: TextOverflow.visible,
        textAlign: _mapTextAlign(textConfig.textAlignRaw),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: _mapFontWeight(textConfig.fontWeight),
          color: _parseHexColor(textModel.color, fallback: Colors.black),
          height: 1.2,
        ),
      );

      // Decide if we need a container (for padding/border/background)
      final needsContainer =
          padLeft + padTop + padRight + padBottom > 0 ||
          radius > 0 ||
          fillColor != Colors.transparent ||
          decoColor != Colors.transparent;

      if (needsContainer) {
        Color? containerColor;
        Border? border;

        // textbg controls fill
        if (fillColor != Colors.transparent) {
          containerColor = fillColor;
        } else {
          containerColor = Colors.transparent;
        }

        // decorationbg controls border color
        if (decoColor != Colors.transparent) {
          border = Border.all(color: decoColor, width: 1.0);
        }

        textChild = Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
            border: border,
            // For text we keep rectangle; "ROUND" is handled via high radius.
            shape: BoxShape.rectangle,
          ),
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

    // ----- IMAGES -----
    for (final TemplateImageConfig imageConfig in template.images) {
      final imageModel = _findImage(imageConfig.id);
      if (imageModel == null) continue;

      final resolvedWidth = _resolveDimension(context, imageConfig.width);
      final resolvedHeight = _resolveDimension(context, imageConfig.height);

      final imgWidth = resolvedWidth <= 0 ? 40.0 : resolvedWidth;
      final imgHeight = resolvedHeight <= 0 ? 40.0 : resolvedHeight;

      final marginLeft = _resolveDimension(context, imageConfig.margin.left);
      final marginTop = _resolveDimension(context, imageConfig.margin.top);

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: border,
        ),
        child: Stack(clipBehavior: Clip.none, children: children),
      ),
    );
  }
}
