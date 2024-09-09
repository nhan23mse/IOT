import 'package:flutter/material.dart';
import 'package:iot_app/ThemeProvider.dart';
import 'package:provider/provider.dart';
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider
    final theme = Theme.of(context);

    return AppBar(
      foregroundColor: theme.textTheme.bodyMedium?.color,
      backgroundColor: theme.primaryColor,
      actions: [
        IconButton(
          icon: Icon(!themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onPressed: () {
            themeProvider.toggleTheme(); // Toggle theme
          },
        ),
        const SizedBox(width: 24),
        const Icon(Icons.notifications_none_outlined),
        const SizedBox(width: 18),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Define the height of the AppBar
}