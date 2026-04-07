import 'package:flutter/material.dart';
import '../models/analysis_models.dart';
import '../services/analysis_service.dart';
import '../services/auth_service.dart';
import '../widgets/hero_input_card.dart';
import '../widgets/action_controls.dart';
import '../widgets/defense_pipeline.dart';
import '../widgets/decision_output_card.dart';
import '../widgets/decomposition_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  bool isAnalyzing = false;
  bool hasResult = false;
  bool showBreakdown = false;
  int currentStep = 0;

  AnalysisResultModel? result;
  String? errorMessage;

  String _decisionToApiString(Decision decision) {
    switch (decision) {
      case Decision.allow:
        return 'ALLOW';
      case Decision.block:
        return 'BLOCK';
      case Decision.hesitate:
        return 'HESITATE';
    }
  }

  Future<void> handleAnalyze() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      isAnalyzing = true;
      hasResult = false;
      showBreakdown = false;
      currentStep = 0;
      result = null;
      errorMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && isAnalyzing) {
        setState(() => currentStep = 1);
      }
    });

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted && isAnalyzing) {
        setState(() => currentStep = 2);
      }
    });

    try {
      final response = await AnalysisService.analyzePrompt(prompt);

      setState(() {
        result = response;
        hasResult = true;
        currentStep = response.decision == Decision.allow ? 3 : 2;
      });

      try {
        await AuthService.updateStats(_decisionToApiString(response.decision));
      } catch (_) {}
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        currentStep = 2;
      });
    } finally {
      if (mounted) {
        setState(() {
          isAnalyzing = false;
        });
      }
    }
  }

  void handleAnalyzeAnother() {
    setState(() {
      hasResult = false;
      result = null;
      currentStep = 0;
      showBreakdown = false;
      errorMessage = null;
      _controller.clear();
    });
  }

  void handleViewBreakdown() {
    if (result == null) return;

    setState(() {
      showBreakdown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!hasResult)
                HeroInputCard(
                  onAnalyze: (prompt) {
                    _controller.text = prompt;
                    handleAnalyze();
                  },
                ),
              const SizedBox(height: 20),
              if (isAnalyzing || hasResult)
                DefensePipeline(
                  isAnalyzing: isAnalyzing,
                  currentStep: currentStep,
                  decision: result?.decision,
                ),
              const SizedBox(height: 20),
              if (hasResult && result != null)
                DecisionOutputCard(
                  decision: result!.decision,
                  riskScore: result!.riskScore,
                  triggeredLayers: result!.triggeredLayers,
                  semanticSimilarity: result!.semanticSimilarity,
                ),
              if (showBreakdown && result != null) ...[
                const SizedBox(height: 20),
                if (result!.decision == Decision.allow &&
                    result!.decomposition != null)
                  DecompositionView(
                    decomposition: result!.decomposition!,
                    claims: result!.claims,
                    ragResults: result!.ragResults,
                    ragEval: result!.ragEval,
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1F2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Defense Breakdown',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Decision: ${_decisionToApiString(result!.decision)}',
                          ),
                          const SizedBox(height: 8),
                          Text('Risk Score: ${result!.riskScore}/100'),
                          const SizedBox(height: 8),
                          Text(
                            'Semantic Similarity: ${result!.semanticSimilarity}%',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Triggered Layers: ${result!.triggeredLayers.isEmpty ? "None" : result!.triggeredLayers.join(", ")}',
                          ),
                        ]),
                  ),
              ],
              if (errorMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.45),
                    ),
                  ),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
              if (hasResult) ...[
                const SizedBox(height: 20),
                ActionControls(
                  onAnalyzeAnother: handleAnalyzeAnother,
                  onViewBreakdown: handleViewBreakdown,
                  onExport: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Not available.'),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
