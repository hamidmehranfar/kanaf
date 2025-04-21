import 'package:flutter/material.dart';

import '/models/post.dart';

class PostCaptionSection extends StatefulWidget {
  final Post post;

  const PostCaptionSection({
    super.key,
    required this.post,
  });

  @override
  State<PostCaptionSection> createState() => _PostCaptionSectionState();
}

class _PostCaptionSectionState extends State<PostCaptionSection> {
  String? displayBio;
  bool isBioExpanded = false;

  @override
  void initState() {
    super.initState();

    if (widget.post.caption.isNotEmpty) {
      String bio = widget.post.caption;

      displayBio = isBioExpanded
          ? bio
          : bio.substring(0, bio.length > 80 ? 80 : bio.length);

      if (!isBioExpanded && bio.length > 80) {
        displayBio = "${displayBio!}...";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${widget.post.user.firstName ?? ''} ",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: displayBio,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (widget.post.caption.length > 80)
            GestureDetector(
              onTap: () {
                setState(() {
                  isBioExpanded = !isBioExpanded;
                });
              },
              child: Text(
                isBioExpanded ? 'نمایش کمتر' : 'بیشتر',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
