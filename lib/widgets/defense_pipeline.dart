import 'package:flutter/material.dart';
import '../models/analysis_models.dart';

class DefensePipeline extends StatelessWidget {
  final bool isAnalyzing;
  final int currentStep;
  final Decision? decision;

  const DefensePipeline({
    super.key,
    required this.isAnalyzing,
    required this.currentStep,
    this.decision,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'id': 0,
        'title': 'User Input',
        'description': 'Prompt submitted for analysis',
        'icon': Icons.search,
        'gated': false,
      },
      {
        'id': 1,
        'title': 'Safety Analysis',
        'description': 'Multi-layer prompt risk detection',
        'icon': Icons.shield_outlined,
        'gated': false,
      },
      {
        'id': 2,
        'title': 'Decision',
        'description': 'ALLOW / BLOCK / HESITATE',
        'icon': Icons.warning_amber_rounded,
        'gated': false,
      },
      {
        'id': 3,
        'title': 'Decomposition',
        'description': 'Structural breakdown into atomic steps',
        'icon': Icons.account_tree_outlined,
        'gated': true,
      },
    ];

    final isAllowed = decision == Decision.allow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Defense Pipeline',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final step = steps[index];
            final stepId = step['id'] as int;
            final gated = step['gated'] as bool;
            final isActive = currentStep >= stepId;
            final isEnabled = !gated || isAllowed;

            final borderColor =
                isActive && isEnabled ? Colors.cyanAccent : Colors.white24;

            final iconColor =
                isActive && isEnabled ? Colors.cyanAccent : Colors.white54;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isEnabled
                    ? const Color(0xFF1C1F2E)
                    : const Color(0xFF161823),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(step['icon'] as IconData, color: iconColor, size: 28),
                  const SizedBox(height: 10),
                  Text(
                    step['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step['description'] as String,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  if (stepId == 3 && !isAllowed && !isAnalyzing)
                    const Text(
                      'Available only if ALLOW',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
