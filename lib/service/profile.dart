import 'package:it_academy/config/app_constants.dart';
import 'package:it_academy/model/updateUser.dart';
import 'package:it_academy/service/base_service/profile.dart';
import 'package:it_academy/utils/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService extends Profile {
  final Ref ref;
  ProfileService(this.ref);

  XFile? uploadImage;

  @override
  Future<Response> updateProfile({required UpdateUser user}) async {
    FormData formData = FormData.fromMap({
      if (uploadImage != null)
        'profile_picture': await MultipartFile.fromFile(uploadImage!.path,
            filename: uploadImage?.name),
      ...user.toMap(),
    });
    final response = await ref.read(apiClientProvider).post(
          AppConstants.updateUser,
          data: formData,
        );
    return response;
  }
}

final profileServiceProvider = Provider((ref) => ProfileService(ref));
