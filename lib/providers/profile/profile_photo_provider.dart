import 'package:cash_swift/cloud_storage/cloud_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilePhotoProvider =
    FutureProviderFamily<String, String>((ref, msId) async {
  return CloudStorage.getUserProfilePictureUrl(msId);
});
