import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/endpoints.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/subscription.dart';
import '../../ui/states.dart';

final subscriptionsProvider = FutureProvider<List<Subscription>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.listSubscriptions,
        decode: (json) => [
          for (final s in json! as List)
            Subscription.fromJson(s as Map<String, dynamic>),
        ],
      );
});

const List<(SubscriptionPlan, String, String, String)> _plans = [
  (
    SubscriptionPlan.free,
    'Free',
    '₹0',
    'Browse and send a limited number of interests.',
  ),
  (
    SubscriptionPlan.premium,
    'Premium',
    '₹499/mo',
    "Unlimited interests, see who's interested in you, priority placement.",
  ),
  (
    SubscriptionPlan.family,
    'Family',
    '₹899/mo',
    'Everything in Premium, for you and the profiles you manage.',
  ),
];

/// Informational only: no payment is taken in v1 (app stores require
/// in-app purchase for digital subscriptions; that's its own phase).
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final subs = ref.watch(subscriptionsProvider);
    final currentPlan =
        subs.value
            ?.where((s) => s.status == SubscriptionStatus.active)
            .firstOrNull
            ?.plan ??
        SubscriptionPlan.free;

    return Scaffold(
      appBar: AppBar(title: const Text('Membership')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(subscriptionsProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
          children: [
            Text(
              'Paid plans are coming soon. Nothing is charged today.',
              style: text.bodyLarge?.copyWith(color: AppColors.mutedForeground),
            ),
            const SizedBox(height: 16),
            ...switch (subs) {
              AsyncValue(:final error?) => [
                ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(subscriptionsProvider),
                ),
              ],
              AsyncValue(hasValue: true) => [
                for (final (plan, name, price, blurb) in _plans)
                  _PlanCard(
                    name: name,
                    price: price,
                    blurb: blurb,
                    current: plan == currentPlan,
                  ),
              ],
              _ => [const LoadingView()],
            },
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.name,
    required this.price,
    required this.blurb,
    required this.current,
  });

  final String name;
  final String price;
  final String blurb;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: current
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.xl2),
        border: Border.all(
          color: current ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: text.headlineMedium)),
              Text(
                current ? 'Current plan' : 'Coming soon',
                style: text.labelMedium?.copyWith(
                  color: current ? AppColors.primary : AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(price, style: text.titleLarge),
          const SizedBox(height: 8),
          Text(
            blurb,
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
