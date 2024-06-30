import 'package:cash_swift/cloud_storage/cloud_storage.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final profilePhotoNotifierProvider =
    StateNotifierProvider<ProfilePhotoNotifier, void>((ref) {
  return ProfilePhotoNotifier();
});

class ProfilePhotoNotifier extends StateNotifier<void> {
  ProfilePhotoNotifier() : super(());

  Future<void> changeProfilePhoto(WidgetRef ref, String msId) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    final String filePath = image == null ? "" : image.path;
    await CloudStorage.uploadProfilePicture(filePath, msId);
    Future.delayed(Duration(seconds: 2), () {
      ref.refresh(profilePhotoProvider(msId).future);
    });
  }
}
