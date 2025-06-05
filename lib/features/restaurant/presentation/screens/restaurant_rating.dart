import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantRatingDialog extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;
  final int initialRating;

  const RestaurantRatingDialog(
      {super.key, required this.onSubmit, this.initialRating = 4});

  @override
  State<RestaurantRatingDialog> createState() => _RestaurantRatingDialogState();
}

class _RestaurantRatingDialogState extends State<RestaurantRatingDialog> {
  int _rating = 4;
  final _commentController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        return GestureDetector(
          onTap: () {
            setState(() => _rating = starValue.toInt());
          },
          child: Icon(
            _rating >= starValue
                ? FontAwesomeIcons.solidStar
                : FontAwesomeIcons.star,
            color: _rating >= starValue ? Colors.amber[500] : Colors.grey[300],
            size: 32,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Rate Your Experience",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xFF00614B)),
            ),
            const SizedBox(height: 12),
            _buildStars(),
            const SizedBox(height: 8),
            Text(
              [
                "Awful",
                "Bad",
                "Okay",
                "Good",
                "Excellent"
              ][_rating.round() - 1],
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              minLines: 2,
              maxLines: 4,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: "Leave a review (optional)",
                labelStyle: TextStyle(color: Colors.grey[700]),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                hintText: "What did you like or dislike?",
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00614B),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                onPressed: _submitting
                    ? null
                    : () async {
                        setState(() => _submitting = true);
                        await widget.onSubmit(
                            _rating, _commentController.text.trim());
                        if (mounted) Navigator.pop(context);
                      },
                icon: const Icon(FontAwesomeIcons.paperPlane,
                    size: 18, color: Colors.white),
                label: const Text("Submit Review",
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
