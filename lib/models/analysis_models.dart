enum Decision { allow, block, hesitate }

Decision decisionFromString(String value) {
  switch (value.toUpperCase()) {
    case 'ALLOW':
      return Decision.allow;
    case 'BLOCK':
      return Decision.block;
    case 'HESITATE':
      return Decision.hesitate;
    default:
      throw Exception('Unknown decision: $value');
  }
}

class DecompositionStepModel {
  final int id;
  final String text;
  final String? sourceSpan;

  DecompositionStepModel({
    required this.id,
    required this.text,
    this.sourceSpan,
  });

  factory DecompositionStepModel.fromJson(Map<String, dynamic> json) {
    return DecompositionStepModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      sourceSpan: json['source_span'],
    );
  }
}

class DecompositionModel {
  final List<DecompositionStepModel> steps;
  final double qualityScore;

  DecompositionModel({
    required this.steps,
    required this.qualityScore,
  });

  factory DecompositionModel.fromJson(Map<String, dynamic> json) {
    final stepsJson = (json['steps'] as List<dynamic>? ?? []);
    return DecompositionModel(
      steps: stepsJson
          .map(
              (e) => DecompositionStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualityScore: (json['quality']?['score'] ?? 0).toDouble(),
    );
  }
}

class ClaimModel {
  final String claim;
  final int sourceStepId;

  ClaimModel({
    required this.claim,
    required this.sourceStepId,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      claim: json['claim'] ?? '',
      sourceStepId: json['source_step_id'] ?? 0,
    );
  }
}

class RagEvidenceChunkModel {
  final String source;
  final String title;
  final String url;
  final String text;
  final double similarity;
  final double? coverage;

  RagEvidenceChunkModel({
    required this.source,
    required this.title,
    required this.url,
    required this.text,
    required this.similarity,
    this.coverage,
  });

  factory RagEvidenceChunkModel.fromJson(Map<String, dynamic> json) {
    return RagEvidenceChunkModel(
      source: json['source'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      text: json['text'] ?? '',
      similarity: (json['similarity'] ?? 0).toDouble(),
      coverage: json['coverage'] != null
          ? (json['coverage'] as num).toDouble()
          : null,
    );
  }
}

class RagResultModel {
  final String claim;
  final int sourceStepId;
  final String verdict;
  final RagEvidenceChunkModel? bestEvidence;

  RagResultModel({
    required this.claim,
    required this.sourceStepId,
    required this.verdict,
    required this.bestEvidence,
  });

  factory RagResultModel.fromJson(Map<String, dynamic> json) {
    return RagResultModel(
      claim: json['claim'] ?? '',
      sourceStepId: json['source_step_id'] ?? 0,
      verdict: json['verdict'] ?? '',
      bestEvidence: json['best_evidence'] != null
          ? RagEvidenceChunkModel.fromJson(
              json['best_evidence'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RagEvalModel {
  final int totalSteps;
  final int hits;
  final int misses;
  final double hitRate;

  RagEvalModel({
    required this.totalSteps,
    required this.hits,
    required this.misses,
    required this.hitRate,
  });

  factory RagEvalModel.fromJson(Map<String, dynamic> json) {
    return RagEvalModel(
      totalSteps: json['total_steps'] ?? 0,
      hits: json['hits'] ?? 0,
      misses: json['misses'] ?? 0,
      hitRate: (json['hit_rate'] ?? 0).toDouble(),
    );
  }
}

class AnalysisResultModel {
  final Decision decision;
  final int riskScore;
  final List<String> triggeredLayers;
  final int semanticSimilarity;
  final DecompositionModel? decomposition;
  final List<ClaimModel> claims;
  final List<RagResultModel> ragResults;
  final RagEvalModel? ragEval;

  AnalysisResultModel({
    required this.decision,
    required this.riskScore,
    required this.triggeredLayers,
    required this.semanticSimilarity,
    required this.decomposition,
    required this.claims,
    required this.ragResults,
    required this.ragEval,
  });

  factory AnalysisResultModel.fromBackendJson(Map<String, dynamic> json) {
    final claimsJson = (json['claims'] as List<dynamic>? ?? []);
    final ragVerification = json['rag_verification'] as Map<String, dynamic>?;
    final ragResultsJson =
        (ragVerification?['results'] as List<dynamic>? ?? []);

    return AnalysisResultModel(
      decision: decisionFromString(json['status'] ?? 'HESITATE'),
      riskScore:
          (((json['decision_meta']?['final_risk'] ?? 0) as num) * 100).round(),
      triggeredLayers: List<String>.from(
        json['decision_meta']?['triggered_layers'] ?? [],
      ),
      semanticSimilarity:
          (((json['decision_meta']?['semantic_similarity'] ?? 0) as num) * 100)
              .round(),
      decomposition: json['decomposition'] != null
          ? DecompositionModel.fromJson(
              json['decomposition'] as Map<String, dynamic>,
            )
          : null,
      claims: claimsJson
          .map((e) => ClaimModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ragResults: ragResultsJson
          .map((e) => RagResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ragEval: ragVerification?['rag_eval'] != null
          ? RagEvalModel.fromJson(
              ragVerification!['rag_eval'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
