import 'package:flutter/material.dart';

import '../core/store.dart';
import '../core/theme.dart';

void go(BuildContext context, String route, {Object? arguments}) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);
void home(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('/13', (_) => false);
void back(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    home(context);
  }
}

void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

class Art extends StatelessWidget {
  const Art(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });
  final String name;
  final double? width, height;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: width,
    height: height,
    fit: fit,
    filterQuality: FilterQuality.high,
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      boxShadow: onPressed == null
          ? []
          : [
              BoxShadow(
                color: orange.withValues(alpha: .16),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
    ),
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 66),
        backgroundColor: orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 6)],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.size = 40, this.courier = false});
  final double size;
  final bool courier;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * .2),
    child: Art(
      courier ? 'courier' : 'profile',
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader(
    this.title, {
    super.key,
    this.menu = false,
    this.close = false,
    this.avatar = true,
    this.trailing,
  });
  final String title;
  final bool menu, close, avatar;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 76,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            tooltip: menu ? 'Menu' : 'Back',
            onPressed: () => menu ? go(context, '/25') : back(context),
            icon: Icon(
              menu
                  ? Icons.menu_rounded
                  : close
                  ? Icons.close
                  : Icons.chevron_left,
              color: ink,
              size: 26,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 48,
            child:
                trailing ??
                (avatar
                    ? IconButton(
                        tooltip: 'My profile',
                        onPressed: () => go(context, '/23'),
                        padding: const EdgeInsets.all(4),
                        icon: const Avatar(),
                      )
                    : null),
          ),
        ],
      ),
    ),
  );
}

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.navigation = false,
    this.menu = false,
    this.close = false,
    this.avatar = true,
    this.trailing,
    this.background = canvas,
  });
  final String title;
  final Widget child;
  final Widget? bottom, trailing;
  final bool navigation, menu, close, avatar;
  final Color background;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    body: SafeArea(
      child: Column(
        children: [
          PageHeader(
            title,
            menu: menu,
            close: close,
            avatar: avatar,
            trailing: trailing,
          ),
          Expanded(child: child),
        ],
      ),
    ),
    bottomNavigationBar: bottom != null
        ? SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 22),
              child: bottom,
            ),
          )
        : navigation
        ? const BottomBar()
        : null,
  );
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      height: 82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(context, Icons.shopping_bag_rounded, 'Cart', '/16'),
          _item(
            context,
            Icons.favorite,
            'Wish list',
            '/15',
            arguments: 'favorites',
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: orange,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white, width: 6),
                ),
              ),
              child: IconButton(
                onPressed: () => home(context),
                tooltip: 'Home',
                icon: const Icon(Icons.home_rounded, color: Colors.white),
                iconSize: 25,
                padding: const EdgeInsets.all(17),
              ),
            ),
          ),
          _item(context, Icons.settings, 'Settings', '/23'),
          _item(context, Icons.person, 'My profile', '/23'),
        ],
      ),
    ),
  );
  Widget _item(
    BuildContext c,
    IconData icon,
    String label,
    String route, {
    Object? arguments,
  }) => IconButton(
    tooltip: label,
    onPressed: () => go(c, route, arguments: arguments),
    icon: Icon(icon, size: 23, color: const Color(0xFFD4D5D6)),
  );
}

class Tabs extends StatelessWidget {
  const Tabs(this.labels, this.selected, this.onChanged, {super.key});
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
    ),
    child: Row(
      children: List.generate(
        labels.length,
        (i) => Expanded(
          child: InkWell(
            onTap: () => onChanged(i),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 3,
                  width: 108,
                  color: selected == i ? orange : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class LabeledField extends StatelessWidget {
  const LabeledField(
    this.label, {
    super.key,
    required this.controller,
    this.obscure = false,
    this.keyboard,
    this.validator,
    this.suffix,
    this.underline = false,
    this.maxLength,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure, underline;
  final TextInputType? keyboard;
  final FormFieldValidator<String>? validator;
  final Widget? suffix;
  final int? maxLength;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: muted, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          validator: validator,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            suffixIcon: suffix,
            counterText: '',
            border: underline
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: pale),
                  )
                : null,
            enabledBorder: underline
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: pale),
                  )
                : null,
            contentPadding: underline
                ? const EdgeInsets.symmetric(vertical: 10)
                : null,
          ),
        ),
      ],
    ),
  );
}

String? requiredValue(String? value) =>
    value == null || value.trim().isEmpty ? 'Please complete this field' : null;
String? emailValidator(String? value) =>
    value != null && RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)
    ? null
    : 'Enter a valid email address';
String? phoneValidator(String? value) =>
    value != null && value.replaceAll(RegExp(r'\D'), '').length >= 8
    ? null
    : 'Enter a valid phone number';

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: canvas,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .06),
          blurRadius: 22,
          offset: const Offset(0, 18),
        ),
      ],
    ),
    child: child,
  );
}

class BagButton extends StatelessWidget {
  const BagButton({super.key});
  @override
  Widget build(BuildContext context) {
    final count = StoreScope.of(context).count;
    return Badge(
      isLabelVisible: count > 0,
      backgroundColor: orange,
      label: Text('$count'),
      child: IconButton(
        tooltip: 'Cart',
        onPressed: () => go(context, '/16'),
        icon: const Icon(Icons.shopping_bag_outlined, color: ink),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.title, this.message, {super.key});
  final String title, message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_rounded, color: orange, size: 54),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted),
          ),
        ],
      ),
    ),
  );
}
