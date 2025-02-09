import 'package:image_picker/image_picker.dart';
import 'package:tostign/features/profile/domain/models/userinfo_model.dart';
import 'package:tostign/interfaces/repository_interface.dart';

abstract class ProfileRepositoryInterface extends RepositoryInterface {
  Future<dynamic> updateProfile(
      UserInfoModel userInfoModel, XFile? data, String token);
  Future<dynamic> changePassword(UserInfoModel userInfoModel);
}
