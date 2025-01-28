import 'package:flutter/material.dart';

import '/widgets/button_item.dart';
import '/widgets/profile/story_section.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/widgets/profile/post_section.dart';

class CreatePostStoryScreen extends StatefulWidget {
  final bool isStory;
  const CreatePostStoryScreen({super.key, required this.isStory});

  @override
  State<CreatePostStoryScreen> createState() => _CreatePostStoryScreenState();
}

class _CreatePostStoryScreenState extends State<CreatePostStoryScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Navigator.of(context).pop();
        },
        icon: Icons.menu,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(widget.isStory ? "استوری جدید" : "پست جدید",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.tertiary
            ),),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,thickness: 1,
            ),
          ),
          const SizedBox(height: 17,),
          Container(
            margin: globalPadding * 6,
            padding: globalPadding * 7.5,
            decoration: BoxDecoration(
              borderRadius: globalBorderRadius * 6,
              color: theme.colorScheme.primary,
            ),
            child: widget.isStory ?
              const StorySection() :
              const PostSection()
          ),
          const SizedBox(height: 9),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,thickness: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonItem(
                width: 200,
                height: 50,
                onTap: (){

                },
                title: "ایجاد",
                color: theme.colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 200,)
        ],
      ),
    );
  }
}
