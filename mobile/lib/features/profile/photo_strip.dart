import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network/endpoints.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../data/api/upload.dart';
import '../../domain/models/photo.dart';
import 'widgets.dart';

const maxPhotos = 6;
const minActivePhotos = 2;
const int _maxUploadBytes = 10 * 1024 * 1024;

/// Photo ids after moving the one at [from] to [to] (`onReorderItem`'s
/// already-adjusted indices).
List<int> movedIds(List<int> ids, int from, int to) {
  final list = [...ids];
  list.insert(to, list.removeAt(from));
  return list;
}

/// `PATCH /profiles/:pid/photos/reorder` -- the server rejects any order
/// that doesn't list every photo id exactly once.
Future<List<PhotoRef>> reorderPhotos(
  ChristimonyApi api,
  int profileId,
  List<int> order,
) => api.send(
  Api.reorderPhotos,
  pathArgs: {'pid': profileId},
  fields: {'order': order},
  decode: (json) => [
    for (final p in json! as List) PhotoRef.fromJson(p as Map<String, dynamic>),
  ],
);

class PhotoStrip extends ConsumerStatefulWidget {
  const PhotoStrip({
    required this.profileId,
    required this.photos,
    required this.isActive,
    required this.onChanged,
    super.key,
  });

  final int profileId;

  /// In display order.
  final List<PhotoRef> photos;

  /// An active profile can't drop below [minActivePhotos].
  final bool isActive;
  final ValueChanged<List<PhotoRef>> onChanged;

  @override
  ConsumerState<PhotoStrip> createState() => _PhotoStripState();
}

class _PhotoStripState extends ConsumerState<PhotoStrip> {
  bool _uploading = false;
  bool _reordering = false;
  int? _deleting;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);

  void _snack(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _add() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() => _uploading = true);
    try {
      final bytes = await photoBytes(file);
      if (!mounted) return;
      if (bytes.length > _maxUploadBytes) {
        return _snack('That photo is too large (10 MB max).');
      }
      await runWithSnack(context, () async {
        final photo = await _api.send(
          Api.createPhoto,
          pathArgs: {'pid': widget.profileId},
          form: jpegUpload('image', bytes),
          decode: (json) => PhotoRef.fromJson(json! as Map<String, dynamic>),
        );
        widget.onChanged([...widget.photos, photo]);
      });
    } on Exception {
      if (mounted) _snack("Couldn't read that photo.");
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _delete(PhotoRef photo) async {
    if (widget.isActive && widget.photos.length <= minActivePhotos) {
      return _snack(
        'An active profile needs at least $minActivePhotos photos. '
        'Add another first, or pause the profile.',
      );
    }
    final ok = await confirm(
      context,
      title: 'Delete this photo?',
      message: "It will be removed from the profile. This can't be undone.",
      action: 'Delete',
    );
    if (!ok || !mounted) return;
    setState(() => _deleting = photo.id);
    await runWithSnack(context, () async {
      await _api.send<void>(
        Api.deletePhoto,
        pathArgs: {'pid': widget.profileId, 'id': photo.id},
        decode: (_) {},
      );
      widget.onChanged([
        for (final p in widget.photos)
          if (p.id != photo.id) p,
      ]);
    });
    if (mounted) setState(() => _deleting = null);
  }

  Future<void> _reorder(int from, int to) async {
    if (_reordering || from == to) return;
    final before = widget.photos;
    final byId = {for (final p in before) p.id: p};
    final order = movedIds([for (final p in before) p.id], from, to);
    widget.onChanged([for (final id in order) byId[id]!]);

    setState(() => _reordering = true);
    final ok = await runWithSnack(context, () async {
      widget.onChanged(await reorderPhotos(_api, widget.profileId, order));
    });
    if (!ok) widget.onChanged(before);
    if (mounted) setState(() => _reordering = false);
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            onReorderItem: _reorder,
            itemBuilder: (context, i) => _Thumb(
              key: ValueKey(photos[i].id),
              photo: photos[i],
              isCover: i == 0,
              busy: _deleting == photos[i].id,
              onDelete: _deleting == null ? () => _delete(photos[i]) : null,
            ),
            footer: photos.length < maxPhotos
                ? _AddTile(uploading: _uploading, onTap: _add)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          photos.length < minActivePhotos
              ? 'Add at least $minActivePhotos photos before activating.'
              : 'Long-press and drag to reorder. The first photo is the cover.',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.photo,
    required this.isCover,
    required this.busy,
    required this.onDelete,
    super.key,
  });

  final PhotoRef photo;
  final bool isCover;
  final bool busy;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: SizedBox(
      width: 104,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Semantics(
            label: isCover ? 'Cover photo' : 'Photo',
            image: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.xl),
              child: CachedNetworkImage(
                imageUrl: photo.thumbUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    const ColoredBox(color: AppColors.secondary),
              ),
            ),
          ),
          if (isCover)
            Positioned(
              left: 6,
              bottom: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.scrim,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    'Cover',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          Positioned(
            top: -4,
            right: -4,
            child: busy
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    tooltip: 'Delete photo',
                    onPressed: onDelete,
                    iconSize: 16,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.scrim,
                      foregroundColor: AppColors.foreground,
                    ),
                    icon: const Icon(Icons.close),
                  ),
          ),
        ],
      ),
    ),
  );
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.uploading, required this.onTap});

  final bool uploading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Add a photo',
    child: InkWell(
      onTap: uploading ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadii.xl),
      child: Container(
        width: 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: uploading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add, color: AppColors.mutedForeground),
      ),
    ),
  );
}
