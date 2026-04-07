import 'package:flutter/material.dart';

class ActionControls extends StatelessWidget {
  final VoidCallback onAnalyzeAnother;
  final VoidCallback onViewBreakdown;
  final VoidCallback onExport;

  const ActionControls({
    super.key,
    required this.onAnalyzeAnother,
    required this.onViewBreakdown,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: onAnalyzeAnother,
          icon: const Icon(Icons.refresh),
          label: const Text("Analyze Another"),
        ),
        OutlinedButton.icon(
          onPressed: onViewBreakdown,
          icon: const Icon(Icons.description_outlined),
          label: const Text("View Breakdown"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: onExport,
          icon: const Icon(Icons.download_outlined),
          label: const Text("Export"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: BorderSide(color: Colors.white.withOpacity(0.12)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
