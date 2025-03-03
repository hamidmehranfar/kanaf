// import 'package:flutter/material.dart';
//
// class CreateStoryPostSection extends StatefulWidget {
//   const CreateStoryPostSection({super.key});
//
//   @override
//   State<CreateStoryPostSection> createState() => _CreateStoryPostSectionState();
// }
//
// class _CreateStoryPostSectionState extends State<CreateStoryPostSection> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         const SizedBox(height: 25),
//         Center(
//           child: Text(
//             widget.isStory ? "استوری جدید" : "پست جدید",
//             style: theme.textTheme.headlineLarge?.copyWith(
//               fontWeight: FontWeight.w300,
//               color: theme.colorScheme.tertiary,
//             ),
//           ),
//         ),
//         const SizedBox(height: 14),
//         Padding(
//           padding: globalPadding * 11,
//           child: MyDivider(
//             color: theme.colorScheme.onSecondary,
//             height: 1,
//             thickness: 1,
//           ),
//         ),
//         const SizedBox(height: 17),
//         Container(
//           margin: globalPadding * 6,
//           padding: globalPadding * 7.5,
//           decoration: BoxDecoration(
//             borderRadius: globalBorderRadius * 6,
//             color: theme.colorScheme.primary,
//           ),
//           child: widget.isStory
//               ? StorySection(
//             post: widget.post,
//           )
//               : PostSection(post: widget.post),
//         ),
//         const SizedBox(height: 9),
//         Padding(
//           padding: globalPadding * 11,
//           child: MyDivider(
//             color: theme.colorScheme.onSecondary,
//             height: 1,
//             thickness: 1,
//           ),
//         ),
//         const SizedBox(height: 12),
//         isLoading()
//             ? SpinKitThreeBounce(
//           size: 14,
//           color: theme.colorScheme.onSecondary,
//         )
//             : Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ButtonItem(
//               width: 200,
//               height: 50,
//               onTap: () async {
//                 await createPost();
//               },
//               title: "ایجاد",
//               color: theme.colorScheme.tertiary,
//             ),
//           ],
//         ),
//         const SizedBox(height: 200)
//       ],
//     );
//   }
// }
