import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/res/app_colors.dart';
import 'package:kanaf/widgets/custom_appbar.dart';
import '../widgets/my_divider.dart';
import '../global_configs.dart';

class SearchScreen extends StatefulWidget {
  final bool isMainScreen;
  const SearchScreen({super.key, required this.isMainScreen});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  List<String> searchList = [];

  @override
  void initState() {
    super.initState();
  }

  void onChangeListener(String searchText){
    searchList.clear();
    if("حمید".contains(searchText) && searchText.isNotEmpty){
      searchList.add("حمید مهران فر");
      searchList.add("حمید مهران فر 2");
      searchList.add("حمید مهران فر 3");
    }
    else{
      searchList.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        onTap: (){
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
        hasShadow: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 17,),
          Text("بررسی", style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w300
          ),),
          const SizedBox(height: 8,),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 18,),
          Container(
            width: SizeController.width(context),
            height: 63,
            margin: globalPadding * 6,
            padding: const EdgeInsets.only(
              left: 11,
              right: 11,
              top: 8,
              bottom: 8
            ),
            decoration: BoxDecoration(
              borderRadius: globalBorderRadius * 5,
              color: theme.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                    color: theme.colorScheme.tertiary,
                    offset: const Offset(-3,-3)
                ),
                BoxShadow(
                    color: theme.colorScheme.onSecondary,
                    offset: const Offset(3, 3)
                )
              ]
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: globalBorderRadius * 5,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8,),
                  Expanded(
                    child: TextField(
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.surface
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "جستجو",
                        hintStyle: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.surface.withOpacity(0.5)
                        )
                      ),
                    )
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: IconButton(
                      onPressed: (){

                      },
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero
                      ),
                      icon: Icon(Icons.search, size: 25,
                        color:theme.colorScheme.tertiary,)
                    ),
                  ),
                  const SizedBox(width: 8,)
                ],
              ),
            ),
          ),
          const SizedBox(height: 14,),
          Expanded(
              child: Padding(
                padding: globalPadding * 6,
                child: SizedBox(
                  width: SizeController.width(context),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                    ),
                    itemBuilder: (context, index){
                      return Container(
                        color: theme.colorScheme.inverseSurface,
                        width: 80,
                        height: 80,
                      );
                    },
                  ),
                ),
              )
          )
          // Expanded(
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemBuilder: (context, index){
          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             padding: globalPadding * 2,
          //             child: Text(searchList[index], style: theme.textTheme.bodyLarge,),
          //           ),
          //           const SizedBox(height: 8,),
          //           MyDivider(color: theme.colorScheme.shadow,
          //               height: 1, thickness: 1).paddingSymmetric(horizontal: 8),
          //           const SizedBox(height: 8,),
          //         ],
          //       );
          //     },
          //     itemCount: searchList.length,
          //   ),
          // )
        ],
      ),
    );
  }
}
