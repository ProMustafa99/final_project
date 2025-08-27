import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onLeadingPressed,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: 0,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Colors.black87,
        ),
      ),
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon, color: iconColor ?? Colors.grey.shade700),
              onPressed: onLeadingPressed ?? () {},
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
