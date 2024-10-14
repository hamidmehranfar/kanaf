import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
    if(!widget.isMainScreen) focus.requestFocus();
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
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Padding(
              padding: allPadding*2,
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: const Icon(Iconsax.arrow_right_1),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: globalPadding * 2,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 2,
                        color: theme.colorScheme.secondary.withOpacity(0.2),
                      ),
                      child: TextField(
                        focusNode: focus,
                        controller: controller,
                        style: theme.textTheme.titleMedium,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "جستجو",
                          hintStyle: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.shadow),
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (searchText) => onChangeListener(searchText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
        bottom: MyDivider(
          color: theme.colorScheme.shadow,
          height: 1,
          thickness: 1,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8,),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: globalPadding * 2,
                      child: Text(searchList[index], style: theme.textTheme.bodyLarge,),
                    ),
                    const SizedBox(height: 8,),
                    MyDivider(color: theme.colorScheme.shadow,
                        height: 1, thickness: 1).paddingSymmetric(horizontal: 8),
                    const SizedBox(height: 8,),
                  ],
                );
              },
              itemCount: searchList.length,
            ),
          )
        ],
      ),
    );
  }
}
