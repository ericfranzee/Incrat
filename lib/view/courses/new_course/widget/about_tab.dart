import 'package:it_academy/components/instructor_card.dart';
import 'package:it_academy/config/app_components.dart';
import 'package:it_academy/config/app_text_style.dart';
import 'package:it_academy/controllers/courses/course.dart';
import 'package:it_academy/model/course_detail.dart';
import 'package:it_academy/utils/context_less_nav.dart';
import 'package:it_academy/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutTab extends ConsumerWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var list = ref.read(courseController).courseDetails!.description;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          children: [
            ...List.generate(
                list.length, (index) => DescriptionCard(model: list[index])),
            InstructorCard(
              model:
                  ref.read(courseController).courseDetails!.course.instructor,
            )
          ],
        ),
      ),
    );
  }
}

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.model,
  });
  final Description model;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: AppComponents.defaultBorderRadiusSmall),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Text(
                // S.of(context).description,
                model.heading,
                style: AppTextStyle(context)
                    .bodyTextSmall
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            10.ph,
            Html(data: model.body)
          ],
        ),
      ),
    );
  }
}
