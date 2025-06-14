import 'package:flutter/material.dart';

class DrippyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final double height;
  final String? username;

  DrippyAppBar({
    required this.title,
    this.actions,
    this.height = kToolbarHeight + 60,
    this.username, // extra space for drip shape
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DripClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6B3E1A), // dark chocolate
              Color(0xFF8B5E26), // lighter chocolate
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.shade900.withOpacity(0.7),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              10, // +10 for extra spacing on top
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                child: title,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (username != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      'Hello, $username',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                if (actions != null) ...actions!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DripClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Draw rectangle top and sides
    path.lineTo(0, size.height - 20);

    // Draw drips at the bottom
    // Adjust these values to get different drip sizes/spacing
    double dripWidth = size.width / 6;

    for (int i = 0; i < 6; i++) {
      double startX = dripWidth * i;

      // Make a drip shape: down, curve up
      path.quadraticBezierTo(
        startX + dripWidth / 4,
        size.height,
        startX + dripWidth / 2,
        size.height - 20,
      );

      path.quadraticBezierTo(
        startX + 3 * dripWidth / 4,
        size.height - 40,
        startX + dripWidth,
        size.height - 20,
      );
    }

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
