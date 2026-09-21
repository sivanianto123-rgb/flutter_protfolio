import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// An "editor window" card that types out a fixed Dart snippet
/// character-by-character on a loop, with a blinking block cursor and basic
/// keyword syntax highlighting.
class TypingCode extends StatefulWidget {
  const TypingCode({super.key});

  static const _snippet =
      'bool isLenientMatch(String spoken, String target) {\n'
      '  final s = spoken.toLowerCase().trim();\n'
      '  final t = target.toLowerCase().trim();\n'
      '  if (s == t) return true;\n'
      '  return phoneticDistance(s, t) <= 2;\n'
      '}';

  static const _typeInterval = Duration(milliseconds: 40);
  static const _holdDuration = Duration(milliseconds: 1500);

  static final _keywords = {
    'bool',
    'String',
    'if',
    'return',
    'final',
  };

  @override
  State<TypingCode> createState() => _TypingCodeState();
}

class _TypingCodeState extends State<TypingCode> {
  Timer? _typeTimer;
  Timer? _holdTimer;
  Timer? _blinkTimer;
  int _charCount = 0;
  bool _cursorVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.of(context).disableAnimations) return;
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
        if (!mounted) return;
        setState(() => _cursorVisible = !_cursorVisible);
      });
      _startTyping();
    });
  }

  void _startTyping() {
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(TypingCode._typeInterval, (timer) {
      if (!mounted) return;
      if (_charCount >= TypingCode._snippet.length) {
        timer.cancel();
        _holdTimer = Timer(TypingCode._holdDuration, () {
          if (!mounted) return;
          setState(() => _charCount = 0);
          _startTyping();
        });
        return;
      }
      setState(() => _charCount++);
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _holdTimer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final visibleText = reducedMotion
        ? TypingCode._snippet
        : TypingCode._snippet.substring(0, _charCount);
    final showCursor = !reducedMotion && _cursorVisible;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorHeader(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: RichText(
              text: TextSpan(
                children: [
                  ..._highlight(visibleText),
                  if (showCursor)
                    const TextSpan(
                      text: '▍',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.accent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _highlight(String text) {
    final spans = <TextSpan>[];
    final tokenPattern = RegExp(r'[A-Za-z_][A-Za-z0-9_]*|\s+|.');
    for (final match in tokenPattern.allMatches(text)) {
      final token = match.group(0)!;
      final isKeyword = TypingCode._keywords.contains(token);
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            height: 1.6,
            fontWeight: isKeyword ? FontWeight.w600 : FontWeight.w400,
            color: isKeyword ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
      );
    }
    return spans;
  }
}

class _EditorHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (final _ in List.filled(3, null))
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary.withValues(alpha: 0.35),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'lenient_match.dart',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
