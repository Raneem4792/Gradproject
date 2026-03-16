import 'package:flutter/material.dart';

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

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFEAF4F2);

  final List<_RatingCriterion> criteria = [
    _RatingCriterion(label: "Taste"),
    _RatingCriterion(label: "Presentation"),
    _RatingCriterion(label: "Portion Size"),
    _RatingCriterion(label: "Temperature"),
    _RatingCriterion(label: "Overall Satisfaction"),
  ];

  bool get _hasAtLeastOneRating =>
      criteria.any((criterion) => criterion.rating > 0);

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (!_hasAtLeastOneRating) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one rating."),
        ),
      );
      return;
    }

    final reviewData = {
      "orderId": widget.orderId,
      "mealName": widget.mealName,
      "ratings": criteria
          .map(
            (criterion) => {
              "label": criterion.label,
              "rating": criterion.rating,
            },
          )
          .toList(),
      "comment": _commentController.text.trim(),
      "reviewedAt": DateTime.now().toIso8601String(),
    };

    Navigator.pop(context, reviewData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const _RateMealAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MealInfoCard(mealName: widget.mealName),
              const SizedBox(height: 16),

              const _SectionTitle(title: "Evaluation Criteria"),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(criteria.length, (index) {
                    final criterion = criteria[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == criteria.length - 1 ? 0 : 16,
                      ),
                      child: _CriteriaRatingRow(
                        label: criterion.label,
                        rating: criterion.rating,
                        onRate: (value) {
                          setState(() {
                            criterion.rating = value;
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),

              const _SectionTitle(title: "Add Notes"),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Write an optional comment...",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.38),
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFA),
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(
                        color: primary,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Send Review",
                    style: TextStyle(
                      fontSize: 14,
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

class _RateMealAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _RateMealAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      shadowColor: Colors.black.withOpacity(0.08),
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "Rate Meal",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealInfoCard extends StatelessWidget {
  final String mealName;

  const _MealInfoCard({required this.mealName});

  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFEAF4F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    softMint,
                    mint.withOpacity(0.35),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    size: 42,
                    color: primary.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                mealName,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
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
        fontSize: 14.5,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _CriteriaRatingRow extends StatelessWidget {
  final String label;
  final int rating;
  final ValueChanged<int> onRate;

  const _CriteriaRatingRow({
    required this.label,
    required this.rating,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.72),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final value = index + 1;
            return IconButton(
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              padding: EdgeInsets.zero,
              onPressed: () => onRate(value),
              icon: Icon(
                value <= rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: const Color(0xFFF4B400),
                size: 24,
              ),
            );
          }),
        ),
      ],
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