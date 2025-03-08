import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_academy/config/app_constants.dart';
import 'package:it_academy/model/contact_support.dart';
import 'package:it_academy/service/base_service/other.dart';
import 'package:it_academy/utils/api_client.dart';

class OtherProvider extends Other {
  final Ref ref;
  OtherProvider(this.ref);

  @override
  Future<Response> makeReview(
      {required int id, required Map<String, dynamic> data}) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstants.review + id.toString(), data: data);
    return response;
  }

  @override
  Future<Response> contactSupport(
      {required ContactSupport contactSupport}) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstants.contactSupport, data: contactSupport.toJson());
    return response;
  }

  @override
  Future<Response> deleteAccount() async {
    final response =
        await ref.read(apiClientProvider).delete(AppConstants.deleteAccount);
    return response;
  }

  @override
  Future<Response> masterCall() async {
    final response = await ref.read(apiClientProvider).get(AppConstants.master);
    return response;
  }
}

final otherServiceProvider = Provider((ref) => OtherProvider(ref));
