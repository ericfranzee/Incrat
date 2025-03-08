import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:it_academy/config/app_color.dart';
import 'package:it_academy/config/app_components.dart';
import 'package:it_academy/config/app_text_style.dart';
import 'package:it_academy/generated/l10n.dart';
import 'package:it_academy/utils/context_less_nav.dart';
import 'package:it_academy/utils/entensions.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.totalCourse,
    required this.color,
    required this.onTap,
    required this.width,
  });
  final String image, title;
  final int totalCourse;
  final Color color;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.all(12.h),
        margin: EdgeInsets.only(right: 12.h),
        decoration: BoxDecoration(
            borderRadius: AppComponents.defaultBorderRadiusLarge,
            color: color.withOpacity(.6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/spinner.gif',
              image: image,
              height: 56.h,
              width: 56.h,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: context.color.primary);
              },
            ),
            8.ph,
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                  color: AppStaticColor.whiteColor,
                  fontWeight: FontWeight.w600),
            ),
            4.ph,
            Text(
              '$totalCourse ${S.of(context).course}',
              style: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(color: AppStaticColor.whiteColor, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
