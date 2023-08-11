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

class NetworkRoundedImageWithStatus extends NetworkRoundedImage {
  final bool isActive;

  NetworkRoundedImageWithStatus({
    Key? key,
    required String imagePath,
    required double imageSize,
    required this.isActive,
  }) : super(imagePath: imagePath, imageSize: imageSize);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        super.build(context),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromRGBO(30, 29, 37, 1.0),
                width: 2,
              ),
            ),
          ),
        ),
      ],
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
