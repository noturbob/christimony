import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../domain/models/photo.dart';
import '../../domain/models/profile.dart';

/// The deck card's content: photos, then the profile, scrolling inside the
/// card. Tapping the name opens the full profile.
class ProfileCardBody extends StatelessWidget {
  const ProfileCardBody({required this.profile, this.onOpen, super.key});

  final Profile profile;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhotoCarousel(photos: p.photos, name: p.name, thumbs: true),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Semantics(
                  button: true,
                  hint: 'Open full profile',
                  child: InkWell(
                    onTap: onOpen,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: ProfileHeading(profile: p),
                  ),
                ),
                if (p.prompts.isNotEmpty)
                  SectionBlock(
                    label: p.prompts.first.question,
                    text: p.prompts.first.answer,
                    emphasis: true,
                  ),
                if (p.bio case final bio? when bio.isNotEmpty)
                  SectionBlock(label: 'About', text: bio),
                if (p.education case final edu? when edu.isNotEmpty)
                  SectionBlock(label: 'Education', text: edu),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Name, age, and `city · denomination · profession`.
class ProfileHeading extends StatelessWidget {
  const ProfileHeading({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final meta = [
      profile.city,
      profile.denomination,
      profile.profession,
    ].where((s) => s != null && s.isNotEmpty).join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: profile.name,
            children: [
              if (profile.age != null)
                TextSpan(
                  text: ', ${profile.age}',
                  style: const TextStyle(
                    color: AppColors.mutedForeground,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          style: text.headlineLarge,
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            meta,
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
      ],
    );
  }
}

class SectionBlock extends StatelessWidget {
  const SectionBlock({
    required this.label,
    required this.text,
    this.emphasis = false,
    super.key,
  });

  final String label;
  final String text;

  /// Prompt answers read larger, like the web's `font-display text-lg`.
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadii.xl2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.labelSmall?.copyWith(
              color: AppColors.mutedForeground,
              letterSpacing: 0.6,
            ),
          ),
          Text(text, style: emphasis ? theme.titleLarge : theme.bodyMedium),
        ],
      ),
    );
  }
}

/// A 4:5 photo carousel. Changing photo is a tap on the left / right half
/// -- taps never compete with the deck's horizontal drag.
class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({
    required this.photos,
    required this.name,
    this.thumbs = false,
    super.key,
  });

  final List<PhotoRef> photos;
  final String name;

  /// Card stacks use `thumb_url`; the full-screen detail uses `url`.
  final bool thumbs;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final photos = [...widget.photos]
      ..sort((a, b) => a.position.compareTo(b.position));
    final fallback = Center(
      child: Text(
        widget.name.isEmpty ? '' : widget.name[0].toUpperCase(),
        style: Theme.of(context).textTheme.displayLarge
            ?.copyWith(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
    );
    final index = _index.clamp(0, photos.isEmpty ? 0 : photos.length - 1);

    void go(int to) => setState(() => _index = to.clamp(0, photos.length - 1));

    return AspectRatio(
      aspectRatio: 4 / 5,
      child: ColoredBox(
        color: AppColors.secondary,
        child: photos.isEmpty
            ? fallback
            : Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.thumbs
                        ? photos[index].thumbUrl
                        : photos[index].url,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    errorWidget: (_, _, _) => fallback,
                  ),
                  if (photos.length > 1) ...[
                    Row(
                      children: [
                        _TapZone('Previous photo', () => go(index - 1)),
                        const Spacer(),
                        _TapZone('Next photo', () => go(index + 1)),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: ExcludeSemantics(
                        child: Row(
                          spacing: 4,
                          children: [
                            for (var i = 0; i < photos.length; i++)
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: i == index ? 1 : 0.4,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _TapZone extends StatelessWidget {
  const _TapZone(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      button: true,
      label: label,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap),
    ),
  );
}
