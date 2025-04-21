import 'package:flutter/material.dart';

class PostHeaderSection extends StatelessWidget {
  final String name;
  final String avatar;

  const PostHeaderSection({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primary,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(name),
              const SizedBox(width: 5),
              SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: Image.network(
                    avatar,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
