import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/dictionary_api.dart';

class WordTapText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const WordTapText({super.key, required this.text, this.style});

  String _cleanWord(String w) {
    return w.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final words = text.split(RegExp(r'\s+'));
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final raw = words[i];
      final cleaned = _cleanWord(raw);

      spans.add(
        TextSpan(
          text: raw + (i == words.length - 1 ? '' : ' '),
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (cleaned.isEmpty) return;
              final api = DictionaryApi(http.Client());
              final meanings = await api.meanings(cleaned);

              if (!context.mounted) return;

              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: meanings.isEmpty
                        ? Text('No meaning found for "$cleaned".')
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cleaned, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              for (final m in meanings) Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('• $m'),
                              ),
                            ],
                          ),
                  );
                },
              );
            },
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
  