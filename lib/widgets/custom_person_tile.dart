import 'package:flutter/material.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class CustomPersonTile extends StatelessWidget {
  final double height;
  final double width;
  final String name;
  final String imgUrl;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  CustomPersonTile({
    Key? key,
    required this.height,
    required this.width,
    required this.name,
    required this.imgUrl,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            )
          : null,
      onTap: () => onTap(),
      leading: NetworkRoundedImageWithStatus(
        imagePath: imgUrl,
        imageSize: height * 0.05,
        isActive: isActive,
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
