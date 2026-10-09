import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';

/// A round photo, falling back to initials -- `cover_photo_url` is null for
/// any profile without photos, so every list needs this.
class Avatar extends StatelessWidget {
  const Avatar({required this.name, this.url, this.size = 48, super.key});

  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = Text(
      _initials(name),
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontSize: size * 0.36, color: AppColors.foreground),
    );

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: AppColors.secondary,
        alignment: Alignment.center,
        child: url == null
            ? initials
            : CachedNetworkImage(
                imageUrl: url!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => initials,
              ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
