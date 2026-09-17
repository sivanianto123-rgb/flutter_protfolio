import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NavItem {
  final String label;
  final VoidCallback onTap;

  const NavItem({required this.label, required this.onTap});
}

/// Fixed/sticky top nav bar with a frosted-glass background once the page
/// has scrolled, and smooth-scroll links to each section.
class NavBar extends StatelessWidget {
  final bool scrolled;
  final List<NavItem> items;
  final String brand;

  const NavBar({
    super.key,
    required this.scrolled,
    required this.items,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    // The full link row needs more breathing room than the general content
    // breakpoint, so it gets its own (higher) threshold before collapsing
    // into the hamburger menu.
    final showFullNav = MediaQuery.of(context).size.width >= 860;

    // The blur/tint only applies to a background layer. Interactive content
    // (brand + links) is stacked on top, outside the BackdropFilter subtree,
    // since nesting gesture detectors inside a BackdropFilter is a known
    // source of flaky hit-testing on the web renderer.
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: scrolled ? 20 : 0,
                  sigmaY: scrolled ? 20 : 0,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: scrolled
                        ? AppColors.background.withValues(alpha: 0.72)
                        : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: scrolled ? AppColors.border : Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Breakpoints.horizontalPadding(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      brand,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  if (showFullNav)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final item in items) _NavLink(item: item),
                      ],
                    )
                  else
                    _MobileNavMenu(items: items),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final NavItem item;
  const _NavLink({required this.item});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _hovering
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
            child: Text(widget.item.label),
          ),
        ),
      ),
    );
  }
}

class _MobileNavMenu extends StatelessWidget {
  final List<NavItem> items;
  const _MobileNavMenu({required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
      color: AppColors.surfaceElevated,
      onSelected: (index) => items[index].onTap(),
      itemBuilder: (context) => [
        for (var i = 0; i < items.length; i++)
          PopupMenuItem(
            value: i,
            child: Text(
              items[i].label,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
      ],
    );
  }
}
