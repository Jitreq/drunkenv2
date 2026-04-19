import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class XrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const XrAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.leadingTap,
    this.trailingTap,
  });

  final String title;
  final IconData? leading;
  final IconData? trailing;
  final VoidCallback? leadingTap;
  final VoidCallback? trailingTap;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      centerTitle: true,
      backgroundColor: AppColors.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      leading: leading == null
          ? null
          : IconButton(
              icon: Icon(leading, color: AppColors.textPrimary),
              onPressed: leadingTap,
            ),
      actions: trailing == null
          ? null
          : [
              IconButton(
                icon: Icon(trailing, color: AppColors.textPrimary),
                onPressed: trailingTap,
              ),
            ],
    );
  }
}
