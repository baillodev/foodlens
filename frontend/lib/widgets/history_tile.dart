import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/history_entry.dart';

class HistoryTile extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onTap;

  const HistoryTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: entry.imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 56,
              height: 56,
              color: Colors.grey[200],
            ),
            errorWidget: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, size: 24),
            ),
          ),
        ),
        title: Text(
          entry.foodSummary.isNotEmpty ? entry.foodSummary : 'Analyse',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy - HH:mm').format(entry.analyzedAt),
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        trailing: Text(
          '${entry.totalCalories.toStringAsFixed(0)} kcal',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
