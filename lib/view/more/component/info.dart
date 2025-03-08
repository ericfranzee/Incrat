import 'package:it_academy/config/app_color.dart';
import 'package:it_academy/config/theme.dart';
import 'package:it_academy/routes.dart';
import 'package:it_academy/service/hive_service.dart';
import 'package:it_academy/utils/context_less_nav.dart';
import 'package:it_academy/view/more/component/info_box_card.dart';
import 'package:it_academy/view/more/component/language.dart';
import 'package:it_academy/view/more/component/mode.dart';
import 'package:it_academy/generated/l10n.dart';
import 'package:it_academy/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        children: [
          24.ph,
          Row(
            children: [
              InfoBoxCard(
                  icon: 'assets/svg/ic_certificates.svg',
                  title: S.of(context).certificates,
                  color: colors(context).primaryColor ??
                      AppStaticColor.primaryColor,
                  onTap: () {
                    context.nav.pushNamed(Routes.certificateScreen);
                  }),
              16.pw,
              Consumer(builder: (context, ref, _) {
                return InfoBoxCard(
                    icon: 'assets/svg/ic_notification.svg',
                    title: S.of(context).notifications,
                    color: AppStaticColor.orangeColor,
                    showNotification:
                        ref.read(hiveStorageProvider).isGuest() ? false : true,
                    onTap: () {});
              })
            ],
          ),
          16.ph,
          const LanguageCard(),
          16.ph,
          const ModeCard(),
          16.ph,
        ],
      ),
    );
  }
}
