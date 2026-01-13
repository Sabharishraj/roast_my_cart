import 'package:flutter/material.dart';
import 'gemini_service.dart';

class ResultPage extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String category;
  final String reason;

  const ResultPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.reason,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  static const yellow = Color(0xFFFFC107);
  static const green = Color(0xFF4CAF50);
  static const red = Color(0xFFE53935);
  static const bg = Color(0xFF0E0E0E);
  static const cardBg = Color(0xFF1A1A1A);

  bool loading = true;
  String? error;

  String verdict = "";
  int necessityScore = 10;
  String roast = "";
  String financialReality = "";
  double avgAnnualReturn = 0.05;
  double futureValue = 0;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    try {
      final rawText = await GeminiService.generate(_buildPrompt());

      String extract(String label) {
        final start = rawText.indexOf('$label:');
        if (start == -1) return '';

        final labels = [
          'ROAST:',
          'FINANCIAL REALITY:',
          'VERDICT:',
          'NECESSITY:',
          'ANNUAL RETURN:'
        ];

        final nextIndexes = labels
            .where((l) => l != '$label:')
            .map((l) => rawText.indexOf(l, start + label.length))
            .where((i) => i != -1)
            .toList();

        final end = nextIndexes.isEmpty
            ? rawText.length
            : nextIndexes.reduce((a, b) => a < b ? a : b);

        return rawText
            .substring(start + label.length + 1, end)
            .trim();
      }

      final roastText = extract('ROAST');
      final financialText = extract('FINANCIAL REALITY');
      final verdictText = extract('VERDICT').toUpperCase();
      final necessityText = extract('NECESSITY');
      final returnText = extract('ANNUAL RETURN');

      int parsedNecessity = int.tryParse(
            RegExp(r'\d+').stringMatch(necessityText) ?? '',
          ) ??
          10;

      parsedNecessity = parsedNecessity.clamp(5, 100);

      if (widget.category.toLowerCase().contains('medicine')) {
        parsedNecessity = 100;
      }

      double parsedReturn = double.tryParse(
            RegExp(r'\d+(\.\d+)?').stringMatch(returnText) ?? '',
          ) ??
          5;

      parsedReturn = (parsedReturn / 100).clamp(0.0, 0.15);

      setState(() {
        roast = roastText;
        financialReality = financialText;
        verdict = verdictText;
        necessityScore = parsedNecessity;
        avgAnnualReturn = parsedReturn;
        futureValue = widget.productPrice * (1 + avgAnnualReturn);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String _buildPrompt() {
    return '''
You are an AI decision-support agent that helps users evaluate purchases.

Tone rules:
- Roast: clever, dry, lightly sarcastic.
- Financial reality: serious, calm, practical. No sarcasm.
- Never mix tones.

ABSOLUTE OUTPUT RULES:
- Plain text only.
- No markdown, symbols, bullet points, or formatting.
- Do not exceed 110 words total.

PRODUCT:
Name: ${widget.productName}
Price: \$${widget.productPrice}
Category: ${widget.category}
Reason: "${widget.reason}"

NECESSITY RULES:
- Necessity must never be below 5%.
- Medicine, healthcare, or life-saving items must be exactly 100%.

RETURNS RULES:
- Provide a realistic average annual return.
- Investment assets may have higher returns.
- Consumable or depreciating items should be low.
- Return value must be between 0% and 15%.

OUTPUT FORMAT (FOLLOW EXACTLY):

ROAST:
(2–3 witty sentences.)

FINANCIAL REALITY:
(2–3 serious, practical sentences.)

VERDICT:
(BUY or SKIP)

NECESSITY:
(X%)

ANNUAL RETURN:
(Y%)
''';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(
          child: CircularProgressIndicator(color: yellow),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "AI analysis failed",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("GO BACK"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final verdictColor = verdict == "BUY" ? green : red;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ROAST MY CART',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _verdictSection(verdictColor),
            const SizedBox(height: 20),
            _necessityMeter(),
            const SizedBox(height: 20),
            _textCard("The Roast", roast),
            const SizedBox(height: 20),
            _textCard("The Financial Reality", financialReality),
            const SizedBox(height: 20),
            _futureValueComparison(),
            const SizedBox(height: 30),
            _resetButton(context),
          ],
        ),
      ),
    );
  }

  Widget _verdictSection(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text("VERDICT",
              style:
                  TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(verdict,
              style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _necessityMeter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("NECESSITY METER",
              style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 12),
          Text("$necessityScore%",
              style: const TextStyle(
                  color: green,
                  fontSize: 36,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: necessityScore / 100,
            minHeight: 8,
            backgroundColor: Colors.white12,
            color: green,
          ),
        ],
      ),
    );
  }

  Widget _textCard(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: yellow.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(content,
              style:
                  const TextStyle(color: Colors.white70, height: 1.5)),
        ],
      ),
    );
  }

  Widget _futureValueComparison() {
    final maxVal =
        futureValue > widget.productPrice ? futureValue : widget.productPrice;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Future Value Comparison",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "${(avgAnnualReturn * 100).toStringAsFixed(0)}% Avg Annual Return",
                style: const TextStyle(color: yellow),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _bar("Spent", widget.productPrice, maxVal, Colors.white38),
              const SizedBox(width: 24),
              _bar("Invested", futureValue, maxVal, yellow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(String label, double value, double max, Color color) {
    final heightFactor = max == 0 ? 0.0 : value / max;

    return Expanded(
      child: Column(
        children: [
          Container(
            height: 140.0 * heightFactor,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "ROAST ANOTHER PRODUCT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
