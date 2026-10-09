import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/endpoints.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/profile.dart';
import '../../ui/avatar.dart';
import '../../ui/states.dart';
import 'widgets.dart';

typedef Block = ({int id, ProfileSummary profile});

final blocksProvider = FutureProvider<List<Block>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.listBlocks,
        decode: (json) => [
          for (final b in (json! as List).cast<Map<String, dynamic>>())
            (
              id: b['id'] as int,
              profile: ProfileSummary.fromJson(
                b['blocked_profile'] as Map<String, dynamic>,
              ),
            ),
        ],
      );
});

class BlockedScreen extends ConsumerWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(blocksProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Blocked people')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(blocksProvider.future),
        child: switch (blocks) {
          AsyncValue(:final error?) => ListView(
            children: [
              ErrorView(
                error: error,
                onRetry: () => ref.invalidate(blocksProvider),
              ),
            ],
          ),
          AsyncValue(:final value?) when value.isEmpty => ListView(
            children: const [
              EmptyView(
                title: "You haven't blocked anyone",
                message:
                    "People you block can't see your profiles or message "
                    "you, and you won't see theirs.",
              ),
            ],
          ),
          AsyncValue(:final value?) => ListView(
            padding: const EdgeInsets.all(16),
            children: [for (final b in value) _BlockTile(b)],
          ),
          _ => const LoadingView(),
        },
      ),
    );
  }
}

class _BlockTile extends ConsumerStatefulWidget {
  const _BlockTile(this.block);
  final Block block;

  @override
  ConsumerState<_BlockTile> createState() => _BlockTileState();
}

class _BlockTileState extends ConsumerState<_BlockTile> {
  bool _busy = false;

  Future<void> _unblock() async {
    setState(() => _busy = true);
    final ok = await runWithSnack(
      context,
      () => ref
          .read(christimonyApiProvider)
          .send<void>(
            Api.deleteBlock,
            pathArgs: {'id': widget.block.id},
            decode: (_) {},
          ),
    );
    if (ok) ref.invalidate(blocksProvider);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.block.profile;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Avatar(name: p.name, url: p.coverPhotoUrl, size: 40),
        title: Text(p.name, overflow: TextOverflow.ellipsis),
        trailing: TextButton(
          onPressed: _busy ? null : _unblock,
          child: const Text('Unblock'),
        ),
      ),
    );
  }
}
