import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../constants/app_sizes.dart';

class ProductImageScreen extends StatelessWidget {
  final String imageUrl;
  final String productName;

  const ProductImageScreen(
      {super.key, required this.imageUrl, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: productName,
          size: AppSizes.heading6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Builder(
                builder: (context) {
                  if (imageUrl.startsWith('http')) {
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    );
                  } else if (imageUrl.startsWith('data:image')) {
                    // It's a base64 string
                    try {
                      String base64String = imageUrl.split(',').last;
                      Uint8List bytes = base64Decode(base64String);
                      return Image.memory(
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.fill,
                          bytes);
                    } catch (e) {
                      return const AppText(text: 'Error loading image');
                    }
                  } else {
                    // Handle invalid image source (neither URL nor base64)
                    return const AppText(text: 'Invalid image source');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
