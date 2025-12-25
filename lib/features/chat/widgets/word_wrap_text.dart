import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/dictionary_api.dart';

class WordTapText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const WordTapText({super.key, required this.text, this.style});

  @override
  State<WordTapText> createState() => _WordTapTextState();
}

class _WordTapTextState extends State<WordTapText> {
  final List<LongPressGestureRecognizer> _recognizers = [];
  int? _highlightedIndex;

  String _cleanWord(String w) {
    return w.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(RegExp(r'\s+'));
    final spans = <TextSpan>[];

    // dispose existing recognizers before creating new ones for this build
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    for (int i = 0; i < words.length; i++) {
      final raw = words[i];
      final cleaned = _cleanWord(raw);
      final isHighlighted = _highlightedIndex == i;

      final baseStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;
      final spanStyle = baseStyle?.copyWith(
        backgroundColor: isHighlighted ? Theme.of(context).colorScheme.primary.withOpacity(0.12) : null,
      );

      final recognizer = LongPressGestureRecognizer()
        ..onLongPress = () {
          if (cleaned.isEmpty) return;

          setState(() {
            _highlightedIndex = i;
          });

          final api = DictionaryApi(http.Client());
          final futureMeanings = api.meanings(cleaned);

          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            builder: (BuildContext ctx) {
              final scale = MediaQuery.of(ctx).size.width / 360;
              final width = MediaQuery.of(ctx).size.width;

              return Container(
                width: width,
                color: Theme.of(ctx).canvasColor,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16 * scale),
                    child: FutureBuilder<List<String>>(
                      future: futureMeanings,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Searching for "${raw}"...', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontSize: 16 * scale, fontWeight: FontWeight.w600)),
                              SizedBox(height: 12 * scale),
                              Center(child: SizedBox(width: 24 * scale, height: 24 * scale, child: const CircularProgressIndicator()))
                            ],
                          );
                        }

                        final meanings = snapshot.data ?? [];

                        if (meanings.isEmpty) {
                          return Text('No meaning found for "${raw}".', style: Theme.of(ctx).textTheme.bodyMedium);
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(raw, style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontSize: 18 * scale, fontWeight: FontWeight.w700)),
                            SizedBox(height: 12 * scale),
                            for (final m in meanings)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8 * scale),
                                child: Text('• $m', style: Theme.of(ctx).textTheme.bodyMedium),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ).whenComplete(() {
            if (mounted) {
              setState(() {
                _highlightedIndex = null;
              });
            }
          });
        };

      _recognizers.add(recognizer);

      spans.add(
        TextSpan(
          text: raw + (i == words.length - 1 ? '' : ' '),
          style: spanStyle,
          recognizer: recognizer,
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
  