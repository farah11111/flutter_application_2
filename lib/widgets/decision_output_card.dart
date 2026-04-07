import 'package:flutter/material.dart';
import '../models/analysis_models.dart';

class DecisionOutputCard extends StatelessWidget {
  final Decision decision;
  final int riskScore;
  final List<String> triggeredLayers;
  final int semanticSimilarity;

  const DecisionOutputCard({
    super.key,
    required this.decision,
    required this.riskScore,
    required this.triggeredLayers,
    required this.semanticSimilarity,
  });

  String get decisionText {
    switch (decision) {
      case Decision.allow:
        return 'ALLOW';
      case Decision.block:
        return 'BLOCK';
      case Decision.hesitate:
        return 'HESITATE';
    }
  }

  IconData get icon {
    switch (decision) {
      case Decision.allow:
        return Icons.check_circle_outline;
      case Decision.block:
        return Icons.cancel_outlined;
      case Decision.hesitate:
        return Icons.warning_amber_rounded;
    }
  }

  Color get color {
    switch (decision) {
      case Decision.allow:
        return Colors.greenAccent;
      case Decision.block:
        return Colors.redAccent;
      case Decision.hesitate:
        return Colors.amberAccent;
    }
  }

  String get subtitle {
    switch (decision) {
      case Decision.allow:
        return 'Prompt is safe and approved for processing';
      case Decision.block:
        return 'Prompt contains potential security risks';
      case Decision.hesitate:
        return 'Prompt requires additional review';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AegisMind Decision',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Comprehensive analysis results and risk assessment',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(icon, size: 72, color: color),
                const SizedBox(height: 12),
                Text(
                  decisionText,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _metricCard(
                title: 'Risk Score',
                value: '$riskScore / 100',
                subtitle: null,
              ),
              const SizedBox(height: 12),
              _metricCard(
                title: 'Triggered Layers',
                value: '${triggeredLayers.length} / 4',
                subtitle: triggeredLayers.join(', '),
              ),
              const SizedBox(height: 12),
              _metricCard(
                title: 'Semantic Match',
                value: '$semanticSimilarity%',
                subtitle: 'Sentence-BERT contextual similarity',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF11131C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
