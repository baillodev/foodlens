import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double score;

  const ConfidenceIndicator({super.key, required this.score});

  Color get _color {
    if (score >= 80) return const Color(0xFF008575);  // teal
    if (score >= 50) return const Color(0xFFFF712C);  // orange doux
    return const Color(0xFF695D46);                    // brun
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (score / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              color: _color,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${score.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            color: _color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
