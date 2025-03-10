import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_academy/config/app_constants.dart';
import 'package:it_academy/model/authentication/signup_credential.dart';
import 'package:it_academy/service/base_service/auth.dart';
import 'package:it_academy/service/hive_service.dart';
import 'package:it_academy/utils/api_client.dart';

class AuthService extends Auth {
  final Ref ref;
  AuthService(this.ref);

  @override
  Future<Response> login(
      {required String contact, required String password}) async {
    final response = await ref.read(apiClientProvider).post(
      AppConstants.loginUrl,
      data: {
        contact.contains('@') ? 'email' : 'phone': contact,
        'password': password,
        'guest_id': ref.read(hiveStorageProvider).guestId()
      },
    );
    return response;
  }

  @override
  Future<Response> registration(
      {required SignUpCredential signUpCredential}) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.register,
          data: signUpCredential.toMap(),
        );
    return response;
  }

  @override
  Future<Response> activeAccount({required String otp}) async {
    final response = await ref.read(apiClientProvider).post(
      AppConstants.activateAccount,
      data: {'code': otp},
    );
    return response;
  }

  @override
  Future<Response> resetPassRequest({required String id}) async {
    final response = await ref.read(apiClientProvider).post(
      AppConstants.resetPassword,
      data: {'email': id},
    );
    return response;
  }

  @override
  Future<Response> validateOtpForResetPass(
      {required String id, required String otp}) async {
    final response = await ref.read(apiClientProvider).post(
      AppConstants.validateOtpForResetPass,
      data: {'email': id, 'otp': otp},
    );
    return response;
  }

  @override
  Future<Response> resetPassword({required String pass}) async {
    final response = await ref.read(apiClientProvider).patch(
      AppConstants.updatePass,
      data: {'password': pass, 'password_confirmation': pass},
    );
    return response;
  }

  @override
  Future<Response> updatePassword(
      {required String oldPass, required String newPass}) async {
    final response = await ref.read(apiClientProvider).patch(
      AppConstants.updatePass,
      data: {
        'current_password': oldPass,
        'password': newPass,
        'password_confirmation': newPass
      },
    );
    return response;
  }

  @override
  Future<Response> getGuestId() async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.guestCreate,
        );
    return response;
  }

  @override
  Future<Response> activeAccountRequest() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstants.activeAccountRequest,
        );
    return response;
  }
}

final authServiceProvider = Provider((ref) => AuthService(ref));
