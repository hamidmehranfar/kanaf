import 'package:flutter/material.dart';

class CollapsingText extends StatefulWidget {
  final String text;

  const CollapsingText({
    super.key,
    required this.text,
  });

  @override
  State<CollapsingText> createState() => _CollapsingTextState();
}

class _CollapsingTextState extends State<CollapsingText> {
  bool isMinimized = true;
  bool isMoreChar = false;

  @override
  void initState() {
    if (widget.text.length > 100) {
      isMoreChar = true;
    }
    super.initState();
  }

  String minimizeText() {
    if (widget.text.length > 100) {
      return "${widget.text.substring(0, 100)}...";
    }
    return widget.text;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isMinimized ? minimizeText() : widget.text,
          style: theme.textTheme.bodyLarge,
        ),
        if (isMoreChar) ...[
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              setState(() {
                isMinimized = !isMinimized;
              });
            },
            child: Text(
              isMinimized ? "بیشتر" : "کمتر",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
