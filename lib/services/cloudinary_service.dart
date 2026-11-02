import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class CloudinaryService {
  // REPLACE THESE WITH YOUR ACTUAL CLOUDINARY CREDENTIALS
  static const String _cloudName = 'dmsilliiw';
  static const String _uploadPreset = 'pq2lqsat';

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  /// Picks a file and uploads it to Cloudinary.
  /// Returns the secure URL of the uploaded file, or null if cancelled/failed.
  /// [fileType] can be FileType.image, FileType.any, etc.
  Future<String?> pickAndUploadFile({
    FileType fileType = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      // 1. Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
        withData: true, // Important for Web
      );

      if (result == null || result.files.isEmpty) {
        return null; // User cancelled
      }

      PlatformFile file = result.files.first;
      
      // WORKAROUND: Cloudinary PDF security often blocks downloads (401).
      // We rename to .txt to bypass this. Cloudinary usually treats .txt as 'Raw'.
      String fileName = file.name;
      CloudinaryResourceType resourceType = CloudinaryResourceType.Auto;
      
      if (file.name.toLowerCase().endsWith('.pdf')) {
        // Rename to .txt
        fileName = file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '_pdf.txt');
        // Use Auto - Cloudinary should detect it's not an image and treat as Raw
        resourceType = CloudinaryResourceType.Auto;
      }

      if (kDebugMode) {
        print('Debug: Uploading $fileName');
        print('Debug: Resource Type: $resourceType');
      }

      // 2. Upload to Cloudinary
      CloudinaryResponse response;

      if (file.bytes != null) {
        // Web or when bytes are available
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromByteData(
            file.bytes!.buffer.asByteData(
              file.bytes!.offsetInBytes,
              file.bytes!.lengthInBytes,
            ),
            identifier: fileName,
            resourceType: resourceType,
          ),
        );
      } else if (file.path != null) {
        // Mobile/Desktop with path
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path!,
            identifier: fileName, // Important to override name here too
            resourceType: resourceType,
          ),
        );
      } else {
        throw Exception("File data not available");
      }

      if (kDebugMode) {
        print('Debug: Upload success. URL: ${response.secureUrl}');
      }

      // 3. Return the URL
      return response.secureUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Cloudinary Upload Error: $e");
      }
      return null;
    }
  }
}
