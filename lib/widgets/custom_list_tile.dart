import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_time_chatify/widgets/rounded_image.dart';

class CustomListTile extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final String subtitle;
  final String imgUrl;
  final bool isActive;
  final bool isActivity;
  final Function onTap;
  final Function onRightSwipe;

  CustomListTile({
    Key? key,
    required this.height,
    required this.width,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
    required this.onRightSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        dismissible: null,
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            autoClose: true,
            flex: 1,
            onPressed: (value) => onRightSwipe(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(18),
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),
      child: ListTile(
        onTap: () => onTap(),
        leading: NetworkRoundedImageWithStatus(
          imagePath: imgUrl,
          imageSize: height,
          isActive: isActive,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: isActivity
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SpinKitThreeBounce(
                    color: Colors.white,
                    size: height * 0.2,
                  ),
                ],
              )
            : Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
