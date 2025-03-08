import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_academy/components/custom_dot.dart';
import 'package:it_academy/config/app_text_style.dart';
import 'package:it_academy/config/theme.dart';
import 'package:it_academy/generated/l10n.dart';
import 'package:it_academy/utils/context_less_nav.dart';
import 'package:it_academy/utils/entensions.dart';

class CourseShortsInfo extends StatelessWidget {
  const CourseShortsInfo({
    super.key,
    required this.totalTime,
    required this.totalEnrolled,
    required this.rating,
    required this.totalRating,
  });
  final String totalTime, totalEnrolled, totalRating, rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          totalTime,
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(color: context.color.inverseSurface, fontSize: 10.sp),
        ),
        8.pw,
        const CustomDot(),
        8.pw,
        Text(
          '$totalEnrolled ${S.of(context).enrolled}',
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(color: context.color.inverseSurface, fontSize: 10.sp),
        ),
        8.pw,
        Container(
          width: 4.h,
          height: 4.h,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors(context).hintTextColor!.withOpacity(.4)),
        ),
        8.pw,
        SvgPicture.asset(
          'assets/svg/ic_star.svg',
          height: 14.h,
          width: 14.h,
        ),
        4.pw,
        Text(
          rating.toString(),
          style: AppTextStyle(context).bodyTextSmall.copyWith(
              color: context.color.inverseSurface,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700),
        ),
        4.pw,
        Text(
          totalRating,
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(color: context.color.inverseSurface, fontSize: 10.sp),
        ),
      ],
    );
  }
}
