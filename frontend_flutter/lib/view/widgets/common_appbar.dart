import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    Key? key,
    this.title,
    this.titleColor,
    this.backgroundColor = MyColor.primaryColor,
    this.centreTitle = false,
    this.titleSize,
    this.elevation = 0.0,
    this.actions,
    this.whiteBackground = false,
    this.automaticallyImplyLeading = true,
    this.leadingWhiteColor = false,
  }) : super(key: key);

  final String? title;
  final Color? titleColor;
  final Color backgroundColor;
  final bool centreTitle;
  final double? titleSize;
  final double elevation;
  final List<Widget>? actions;
  final bool whiteBackground;
  final bool automaticallyImplyLeading;
  final bool leadingWhiteColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                  color: titleColor == null
                      ? whiteBackground
                          ? MyColor.primaryColor
                          : Colors.white
                      : titleColor,
                  fontSize: titleSize),
            )
          : null,
      centerTitle: centreTitle,
      backgroundColor: whiteBackground ? Colors.white : backgroundColor,
      elevation: elevation,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme:
          IconThemeData(color: leadingWhiteColor ? Colors.white : Colors.grey),
      actionsIconTheme:
          IconThemeData(color: leadingWhiteColor ? Colors.white : Colors.grey),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              whiteBackground ? Colors.grey.shade400 : backgroundColor),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
