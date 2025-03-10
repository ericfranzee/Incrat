import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:it_academy/components/offline.dart';
import 'package:it_academy/config/hive_contants.dart';
import 'package:it_academy/controllers/others.dart';
import 'package:it_academy/routes.dart';
import 'package:it_academy/service/hive_service.dart';
import 'package:it_academy/utils/api_client.dart';
import 'package:it_academy/utils/context_less_nav.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ConnectivityWrapper.instance.onStatusChange.listen((event) {
        if (event == ConnectivityStatus.CONNECTED) {
          ref.read(othersController.notifier).getMasterData().then((value) {
            final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
            var firstOpen =
                appSettingsBox.get(AppHSC.firstOpen, defaultValue: true);
            if (!ref.read(othersController)) {
              if (ref.read(othersController.notifier).masterModel != null) {
                if (!ref.read(hiveStorageProvider).isGuest()) {
                  ref.read(apiClientProvider).updateToken(
                      token: ref.read(hiveStorageProvider).getAuthToken()!);
                }
                context.nav.pushNamedAndRemoveUntil(
                    firstOpen ? Routes.authHomeScreen : Routes.dashboard,
                    (route) => false);
              }
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ref.read(hiveStorageProvider).getTheme()
                  ? 'assets/images/app_name_logo_dark.png'
                  : 'assets/images/app_name_logo_light.png',
              width: 150.h,
              height: 80.h,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
