import 'package:flutter/material.dart';
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
    _RatingCriterion(label: "Taste"),
    _RatingCriterion(label: "Presentation"),
    _RatingCriterion(label: "Portion Size"),
    _RatingCriterion(label: "Temperature"),
    _RatingCriterion(label: "Overall Satisfaction"),
  ];

  bool get _hasAtLeastOneRating => criteria.any((c) => c.rating > 0);

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_hasAtLeastOneRating) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one rating.")),
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
        const SnackBar(content: Text("Review submitted successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Rate Meal"),
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
                  Text(c.label),
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
                          value <= c.rating
                              ? Icons.star
                              : Icons.star_border,
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
              decoration: const InputDecoration(
                hintText: "Write comment...",
                border: OutlineInputBorder(),
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
                    : const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingCriterion {
  final String label;
  int rating;

  _RatingCriterion({
    required this.label,
    this.rating = 0,
  });
}