import 'package:flutter/material.dart';

class HeroInputCard extends StatefulWidget {
  final Function(String) onAnalyze;

  const HeroInputCard({super.key, required this.onAnalyze});

  @override
  State<HeroInputCard> createState() => _HeroInputCardState();
}

class _HeroInputCardState extends State<HeroInputCard> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onAnalyze(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1B2233).withOpacity(0.92),
              const Color(0xFF171E2E).withOpacity(0.92),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.06),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Text(
              "Submit a Prompt for Analysis",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "AegisMind evaluates intent, safety, and semantic risk using layered AI defense.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.45),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 7,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: "Enter your prompt here...",
                contentPadding: EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.shield_outlined),
                label: const Text(
                  "Analyze Prompt",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
