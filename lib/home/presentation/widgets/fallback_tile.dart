import 'package:flutter/material.dart';

import '../template_engine/models/home_screen/carousel_tile/carousel_tile.dart';
import '../template_engine/models/home_screen/carousel_tile/carousel_tile_click_action.dart';

/// Very simple fallback tile when we don't have a template for a section.
///
/// It just lists all text entries vertically.
class FallbackTile extends StatelessWidget {
  final CarouselTile tile;

  const FallbackTile({
    super.key,
    required this.tile,
  });

  void _handleClick(BuildContext context, TileClickAction action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Clicked: ${action.clickId}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleClick(context, tile.onClick),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final t in tile.texts)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${t.id}: ${t.text}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
