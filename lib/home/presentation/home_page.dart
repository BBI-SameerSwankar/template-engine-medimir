import 'package:flutter/material.dart';

import '../data/home_data_loader.dart';
import 'widgets/carousel_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS-style system grouped bg
      appBar: AppBar(
        title: const Text('Dynamic Home Carousels'),
      ),
      body: FutureBuilder<HomeData>(
        future: loadHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data!;
          final carousels = data.carousels;
          final templates = data.templates;

          if (carousels.isEmpty) {
            return const Center(child: Text('No carousels found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: carousels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final carousel = carousels[index];
              final template = templates[carousel.templateId];

              return CarouselSection(
                carousel: carousel,
                template: template, // can be null for sections without template
              );
            },
          );
        },
      ),
    );
  }
}
