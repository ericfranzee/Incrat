import 'package:it_academy/components/category_card.dart';
import 'package:it_academy/config/app_constants.dart';
import 'package:it_academy/model/category.dart';
import 'package:it_academy/routes.dart';
import 'package:it_academy/utils/context_less_nav.dart';
import 'package:it_academy/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Category extends StatelessWidget {
  const Category({super.key, required this.categoryList});
  final List<CategoryModel> categoryList;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          16.pw,
          ...List.generate(
              categoryList.length,
              (index) => CategoryCard(
                  image: categoryList[index].image ??
                      AppConstants.defaultAvatarImageUrl,
                  width: 152.h,
                  title: categoryList[index].title ?? "Demo",
                  totalCourse: categoryList[index].courseCount ?? 0,
                  color: categoryList[index].color!.toColor(),
                  onTap: () {
                    context.nav.pushNamed(Routes.allCourseScreen,
                        arguments: {'model': categoryList[index]});
                  })),
          4.pw
        ],
      ),
    );
  }
}
