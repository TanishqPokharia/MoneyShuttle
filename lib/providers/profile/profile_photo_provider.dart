import 'package:cash_swift/services/cloud_storage_service/cloud_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilePhotoProvider =
    FutureProviderFamily<String, String>((ref, msId) async {
  return CloudStorageService.getUserProfilePictureUrl(msId);
});
