import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:it_academy/components/buttons/app_button.dart';
import 'package:it_academy/components/custom_header_appbar.dart';
import 'package:it_academy/components/shimmer.dart';
import 'package:it_academy/config/app_constants.dart';
import 'package:it_academy/config/app_text_style.dart';
import 'package:it_academy/config/theme.dart';
import 'package:it_academy/controllers/courses/course.dart';
import 'package:it_academy/controllers/favourites_tab.dart';
import 'package:it_academy/generated/l10n.dart';
import 'package:it_academy/routes.dart';
import 'package:it_academy/utils/context_less_nav.dart';
import 'package:it_academy/utils/entensions.dart';
import 'package:it_academy/view/courses/new_course/widget/couse_details.dart';

import '../../../config/app_color.dart';
import '../../../controllers/dashboard_nav.dart';
import 'widget/about_tab.dart';
import 'widget/lessons_tab.dart';
import 'widget/reviews_tab.dart';

class CourseNewScreen extends ConsumerStatefulWidget {
  const CourseNewScreen(
      {super.key,
      required this.courseId,
      this.isShowBottomNavigationBar = true});
  final int courseId;
  final bool isShowBottomNavigationBar;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseNewViewState();
}

class _CourseNewViewState extends ConsumerState<CourseNewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  Future<void> init() async {
    ref.read(courseController.notifier).getNewCourseDetails(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(courseController).courseDetails;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Set the height to zero
        child: AppBar(
          elevation:
              0, // Optional: Set elevation to zero for a completely flat look
          automaticallyImplyLeading: false, // Optional: Hide the back button
        ),
      ),
      body: Column(
        children: [
          CustomHeaderAppBar(
            title: S.of(context).courseDetails,
            widget: GestureDetector(
              onTap: () {
                if (model != null) {
                  ref
                      .read(favouriteTabController.notifier)
                      .favouriteUpdate(id: model.course.id)
                      .then((value) {
                    if (value.isSuccess) {
                      if (value.response == true) {
                        ref
                            .read(favouriteTabController.notifier)
                            .addFavouriteOnList(model);
                      }
                      if (value.response == false) {
                        ref
                            .read(favouriteTabController.notifier)
                            .removeFavouriteOnList(model.course.id);
                      }
                      ref.read(courseController.notifier).updateFavouriteItem();
                    }
                  });
                }
              },
              child: SvgPicture.asset(
                ref.watch(courseController).isFavourite &&
                        !ref.watch(courseController).isLoading
                    ? 'assets/svg/ic_heart.svg'
                    : 'assets/svg/ic_inactive_heart.svg',
                width: 24.h,
                height: 24.h,
              ),
            ),
            onTap: () {
              ref.read(courseController).videoPlayerController?.dispose();
              context.nav.pop();
            },
          ),
          Expanded(
            child: ref.watch(courseController).isLoading || model == null
                ? const ShimmerWidget()
                : DefaultTabController(
                    length: 3,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              CourseDetails(
                                model: model,
                              )
                            ]),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(
                              child: Container(
                                color: context.color.surface,
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        S.of(context).about,
                                        style:
                                            AppTextStyle(context).bodyTextSmall,
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        S.of(context).lessons,
                                        style:
                                            AppTextStyle(context).bodyTextSmall,
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        S.of(context).reviews,
                                        style:
                                            AppTextStyle(context).bodyTextSmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          const AboutTab(),
                          const LessonsTab(),
                          ReviewsTab(model: model)
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: !widget.isShowBottomNavigationBar
          ? null
          : Container(
              width: double.infinity,
              color: context.color.surface,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          model?.course.isFree != null
                              ? Text(
                                  model?.course.isFree == 1
                                      ? S.of(context).free
                                      : '${AppConstants.currencySymbol}${model?.course.price ?? model?.course.regularPrice}',
                                  style: AppTextStyle(context).subTitle,
                                )
                              : 4.pw,
                          model?.course.price != null ||
                                  model?.course.isFree == 1
                              ? model?.course.regularPrice != null
                                  ? Text(
                                      '${AppConstants.currencySymbol}${model?.course.regularPrice}',
                                      style: AppTextStyle(context)
                                          .buttonText
                                          .copyWith(
                                            color:
                                                colors(context).hintTextColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor:
                                                colors(context).hintTextColor,
                                          ),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                        ],
                      ),
                      const Spacer(),
                      ref.watch(freeCourseEnrollController)
                          ? const CircularProgressIndicator()
                          : AppButton(
                              title: S.of(context).enrolNow,
                              titleColor: context.color.surface,
                              textPaddingHorizontal: 16.h,
                              textPaddingVertical: 12.h,
                              onTap: () {
                                if (model != null) {
                                  if (model.course.isFree == 1) {
                                    ref
                                        .read(
                                            freeCourseEnrollController.notifier)
                                        .freeCourseEnroll(
                                            courseId: model.course.id)
                                        .then((response) {
                                      if (response.isSuccess) {
                                        courseEnrollSuccessDialog(
                                          context: context,
                                          ref: ref,
                                        );
                                      }
                                    });
                                  } else {
                                    ref
                                        .read(courseController)
                                        .videoPlayerController
                                        ?.pause();

                                    context.nav.pushNamed(Routes.checkOutScreen,
                                        arguments: widget.courseId);
                                  }
                                }
                              },
                            )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

courseEnrollSuccessDialog({
  required BuildContext context,
  required WidgetRef ref,
}) {
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: context.color.surface,
      shadowColor: context.color.surface,
      backgroundColor: context.color.surface,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.w))),
      content: Container(
        width: MediaQuery.of(context).size.width - 30.h,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.h,
              height: 60.h,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppStaticColor.greenColor),
              child: Center(
                child: Icon(
                  Icons.done_rounded,
                  color: context.color.surface,
                  size: 32.h,
                ),
              ),
            ),
            16.ph,
            Text(
              S.of(context).coourseEnrolledSuccess,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).title.copyWith(
                    fontSize: 22.sp,
                  ),
            ),
            20.ph,
            AppButton(
              title: S.of(context).startLearning,
              width: double.infinity,
              titleColor: context.color.surface,
              textPaddingVertical: 13.h,
              onTap: () {
                context.nav.pushNamedAndRemoveUntil(
                    Routes.dashboard, (route) => false);
                ref.read(homeTabControllerProvider.notifier).state = 1;
              },
            )
          ],
        ),
      ),
    ),
  );
}
