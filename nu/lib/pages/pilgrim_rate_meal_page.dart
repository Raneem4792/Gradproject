import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/rate_service.dart';

class PilgrimRateMealPage extends StatefulWidget {
  final String orderId;
  final String mealName;

  const PilgrimRateMealPage({
    super.key,
    required this.orderId,
    required this.mealName,
  });

  @override
  State<PilgrimRateMealPage> createState() => _PilgrimRateMealPageState();
}

class _PilgrimRateMealPageState extends State<PilgrimRateMealPage> {
  final TextEditingController _commentController = TextEditingController();
  final RateService _rateService = RateService();

  bool _isSubmitting = false;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  final List<_RatingCriterion> criteria = [
    _RatingCriterion(key: "taste"),
    _RatingCriterion(key: "presentation"),
    _RatingCriterion(key: "portionSize"),
    _RatingCriterion(key: "temperature"),
    _RatingCriterion(key: "overallSatisfaction"),
  ];

  bool get _hasAtLeastOneRating => criteria.any((c) => c.rating > 0);

  String _criterionLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case "taste":
        return l10n.taste;
      case "presentation":
        return l10n.presentation;
      case "portionSize":
        return l10n.portionSize;
      case "temperature":
        return l10n.temperature;
      case "overallSatisfaction":
        return l10n.overallSatisfaction;
      default:
        return key;
    }
  }

  IconData _criterionIcon(String key) {
    switch (key) {
      case "taste":
        return Icons.restaurant_menu_rounded;
      case "presentation":
        return Icons.auto_awesome_rounded;
      case "portionSize":
        return Icons.rice_bowl_rounded;
      case "temperature":
        return Icons.thermostat_rounded;
      case "overallSatisfaction":
        return Icons.favorite_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_hasAtLeastOneRating) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectAtLeastOneRating)),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      int total = 0;
      int count = 0;

      for (var c in criteria) {
        if (c.rating > 0) {
          total += c.rating;
          count++;
        }
      }

      final avgRating = count == 0 ? 0 : (total / count).round();

      await _rateService.submitRate(
        orderID: int.parse(widget.orderId),
        stars: avgRating,
        comment: _commentController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reviewSubmittedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${l10n.failed}: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          l10n.rateMeal,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RateHeroCard(mealName: widget.mealName),

              const SizedBox(height: 18),

              const _SectionTitle(title: "Rating Details"),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: Column(
                  children: criteria.map((c) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RatingRow(
                        label: _criterionLabel(l10n, c.key),
                        icon: _criterionIcon(c.key),
                        rating: c.rating,
                        onRatingChanged: (value) {
                          setState(() {
                            c.rating = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18),

              const _SectionTitle(title: "Comment"),

              const SizedBox(height: 10),

              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: l10n.writeComment,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : Text(
                          l10n.submit,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RateHeroCard extends StatelessWidget {
  final String mealName;

  const _RateHeroCard({required this.mealName});

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryDark, primary, primaryMid],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Share your meal experience",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -26,
            top: -26,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mint.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -38,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gold.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _RatingRow({
    required this.label,
    required this.icon,
    required this.rating,
    required this.onRatingChanged,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final value = i + 1;
              final selected = value <= rating;

              return IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 42,
                  minHeight: 42,
                ),
                onPressed: () => onRatingChanged(value),
                icon: Icon(
                  selected ? Icons.star_rounded : Icons.star_border_rounded,
                  color: selected ? const Color(0xFFFFB545) : Colors.black26,
                  size: 34,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1E1E1E),
      ),
    );
  }
}

class _RatingCriterion {
  final String key;
  int rating;

  _RatingCriterion({
    required this.key,
    this.rating = 0,
  });
}