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
        title: Text(l10n.rateMeal),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.mealName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ...criteria.map(
              (c) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(_criterionLabel(l10n, c.key))),
                  Row(
                    children: List.generate(5, (i) {
                      final value = i + 1;
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            c.rating = value;
                          });
                        },
                        icon: Icon(
                          value <= c.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: l10n.writeComment,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(l10n.submit),
              ),
            ),
          ],
        ),
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