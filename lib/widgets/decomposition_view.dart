import 'package:flutter/material.dart';
import '../models/analysis_models.dart';

class DecompositionView extends StatelessWidget {
  final DecompositionModel decomposition;
  final List<ClaimModel> claims;
  final List<RagResultModel> ragResults;
  final RagEvalModel? ragEval;

  const DecompositionView({
    super.key,
    required this.decomposition,
    required this.claims,
    required this.ragResults,
    required this.ragEval,
  });

  List<ClaimModel> _claimsForStep(int stepId) {
    return claims.where((c) => c.sourceStepId == stepId).toList();
  }

  List<RagResultModel> _ragForStep(int stepId) {
    return ragResults.where((r) => r.sourceStepId == stepId).toList();
  }

  Color _verdictColor(String verdict) {
    switch (verdict) {
      case 'SUPPORTED_WEAK':
        return Colors.greenAccent;
      case 'WEAK':
        return Colors.amberAccent;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prompt Decomposition',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 16),
          if (ragEval != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF11131C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Wrap(
                spacing: 18,
                runSpacing: 8,
                children: [
                  Text('Claims: ${ragEval!.totalSteps}'),
                  Text('Hits: ${ragEval!.hits}'),
                  Text('Misses: ${ragEval!.misses}'),
                  Text(
                      'Hit Rate: ${(ragEval!.hitRate * 100).toStringAsFixed(1)}%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...decomposition.steps.map((step) {
            final stepClaims = _claimsForStep(step.id);
            final stepRag = _ragForStep(step.id);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF11131C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${step.id}',
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.text,
                    style: const TextStyle(fontSize: 15),
                  ),
                  if (stepClaims.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'Claims',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...stepClaims.map(
                      (claim) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• ${claim.claim}'),
                      ),
                    ),
                  ],
                  if (stepRag.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    const Text(
                      'RAG Verification',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...stepRag.map(
                      (rag) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D27),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verdict: ${rag.verdict}',
                              style: TextStyle(
                                color: _verdictColor(rag.verdict),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              rag.claim,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (rag.bestEvidence != null) ...[
                              Text('Source: ${rag.bestEvidence!.source}'),
                              const SizedBox(height: 4),
                              Text('Title: ${rag.bestEvidence!.title}'),
                              const SizedBox(height: 4),
                              Text(
                                'Similarity: ${rag.bestEvidence!.similarity.toStringAsFixed(2)}',
                              ),
                              if (rag.bestEvidence!.coverage != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Coverage: ${rag.bestEvidence!.coverage!.toStringAsFixed(2)}',
                                  ),
                                ),
                              const SizedBox(height: 8),
                              if (rag.bestEvidence!.url.isNotEmpty)
                                SelectableText(
                                  rag.bestEvidence!.url,
                                  style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              ExpandableEvidenceText(
                                text: rag.bestEvidence!.text,
                              ),
                            ] else
                              const Text(
                                'No evidence retrieved.',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            'Decomposition quality score: ${(decomposition.qualityScore * 100).round()}%',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableEvidenceText extends StatefulWidget {
  final String text;
  final int previewLength;

  const ExpandableEvidenceText({
    super.key,
    required this.text,
    this.previewLength = 220,
  });

  @override
  State<ExpandableEvidenceText> createState() => _ExpandableEvidenceTextState();
}

class _ExpandableEvidenceTextState extends State<ExpandableEvidenceText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final fullText = widget.text.trim();
    final isLong = fullText.length > widget.previewLength;

    final displayText = !isLong
        ? fullText
        : expanded
            ? fullText
            : '${fullText.substring(0, widget.previewLength)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            height: 1.45,
          ),
        ),
        if (isLong) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Text(
              expanded ? 'See less' : 'See more',
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
