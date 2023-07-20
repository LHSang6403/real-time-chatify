import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NetworkRoundedImage extends StatelessWidget {
  final String imagePath;
  final double imageSize;

  const NetworkRoundedImage(
      {Key? key, required this.imagePath, required this.imageSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(imageSize),
        ),
        color: Colors.black,
      ),
    );
  }
}

class AssetRoundedImage extends StatelessWidget {
  PlatformFile profileImage;
  final double imageSize;

  AssetRoundedImage(
      {Key? key, required this.profileImage, required this.imageSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(profileImage.path.toString()), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(imageSize),
        ),
        color: Colors.black,
      ),
    );
  }
}
