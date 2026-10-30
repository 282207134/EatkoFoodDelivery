import 'package:flutter/material.dart';

import '../../core/store.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'My profile',
      close: true,
      avatar: false,
      navigation: true,
      trailing: IconButton(
        tooltip: 'Search food',
        onPressed: () => go(context, '/15'),
        icon: const Icon(Icons.search),
      ),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 42),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => editProfile(context),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6F0),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Avatar(size: 93),
                      ),
                      const Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(Icons.edit, size: 20, color: orange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  s.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(s.email, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    shortcut(
                      context,
                      Icons.favorite,
                      'Wish List',
                      ink,
                      () => go(context, '/15', arguments: 'favorites'),
                    ),
                    shortcut(
                      context,
                      Icons.star,
                      'Following',
                      orange,
                      () => showDialog<void>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Following'),
                          content: const Text(
                            'Eatko Kitchen · Bristol\nFresh meals and local favorites.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(c).pop();
                                go(context, '/15');
                              },
                              child: const Text('Browse menu'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    shortcut(
                      context,
                      Icons.schedule,
                      'Viewed',
                      ink,
                      () => go(context, '/15', arguments: 'viewed'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            minTileHeight: 80,
            leading: badge(Icons.settings_outlined, orange),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => editProfile(context),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            minTileHeight: 80,
            leading: badge(Icons.location_on_outlined, const Color(0xFFFFA5A5)),
            title: const Text('Shipping address'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => go(context, '/18'),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            minTileHeight: 80,
            leading: badge(
              Icons.shopping_cart_outlined,
              const Color(0xFFFFB224),
            ),
            title: const Text('My cart'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => go(context, '/16'),
          ),
        ],
      ),
    );
  }

  Widget shortcut(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 61,
          height: 61,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 14),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
  Widget badge(IconData icon, Color color) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .13),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Icon(icon, color: color),
  );
}

Future<void> editProfile(BuildContext context) async {
  final s = StoreScope.of(context);
  final name = TextEditingController(text: s.name),
      email = TextEditingController(text: s.email);
  final form = GlobalKey<FormState>();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (c) => Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        28,
        24,
        MediaQuery.viewInsetsOf(c).bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              LabeledField(
                'Your Name',
                controller: name,
                validator: requiredValue,
              ),
              LabeledField(
                'Email Address',
                controller: email,
                keyboard: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              PrimaryButton(
                'Save',
                onPressed: () {
                  if (form.currentState!.validate()) {
                    s.name = name.text.trim();
                    s.email = email.text.trim();
                    s.update();
                    Navigator.of(c).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
  // The closing sheet retains its fields during its reverse animation.
  await Future<void>.delayed(const Duration(milliseconds: 350));
  name.dispose();
  email.dispose();
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int selected = 2;
  final comment = TextEditingController();
  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Review food courier',
    avatar: false,
    trailing: IconButton(
      tooltip: 'Search food',
      onPressed: () => go(context, '/15'),
      icon: const Icon(Icons.search),
    ),
    background: Colors.white,
    bottom: PrimaryButton(
      'Review',
      onPressed: () {
        final s = StoreScope.of(context);
        s.rating = selected;
        s.review = comment.text.trim();
        s.update();
        showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Thank you!'),
            content: const Text(
              'Your delivery review has been saved on this device.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(c).pop();
                  home(context);
                },
                child: const Text('Back to home'),
              ),
            ],
          ),
        );
      },
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Avatar(size: 93, courier: true),
          ),
          const SizedBox(height: 22),
          const Text(
            'Manuel C. Smith',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            '154 reviews',
            style: TextStyle(color: orange, fontSize: 14),
          ),
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () => setState(() => selected = i),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 54,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected == i
                              ? const Color(0xFFFFE8AA)
                              : canvas,
                          boxShadow: selected == i
                              ? [
                                  const BoxShadow(
                                    color: Color(0x33FFB52F),
                                    blurRadius: 18,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          ['🥺', '😀', '😍'][i],
                          style: const TextStyle(fontSize: 34),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ['Bad', 'Good', 'Excellent'][i],
                        style: TextStyle(
                          fontSize: 11,
                          color: selected == i ? ink : muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Write something', style: TextStyle(color: muted)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: comment,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(
              fillColor: pale,
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(24),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    Widget entry(String title, String subtitle, String route) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 26),
      minTileHeight: 104,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: Color(0xFF302C48),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFFC4C4C8), fontSize: 13),
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => go(
        context,
        route,
        arguments: title == 'My orders' ? 'previous' : null,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader('', close: true, avatar: false),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 30, 26, 45),
              child: Row(
                children: [
                  const Avatar(size: 62),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(s.email, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(
                          'Phone: ${s.phone}',
                          style: const TextStyle(fontSize: 10, color: muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  entry('My orders', 'See all my orders', '/16'),
                  entry('My profile', 'See my profile', '/23'),
                  entry('Payment Card', 'Set or add your payment card', '/21'),
                  entry('Cart', 'See all cart items', '/16'),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 26),
                    minTileHeight: 80,
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.logout),
                    onTap: () =>
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/05', (_) => false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
