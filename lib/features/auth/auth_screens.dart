import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/store.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';
import '../../shared/map_art.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.autoAdvance = true});
  final bool autoAdvance;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    if (!widget.autoAdvance) return;
    timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/02');
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Colors.white,
    body: Center(child: Art('logo', width: 148, height: 148)),
  );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    const images = [
      'onboarding_food',
      'onboarding_delivery',
      'onboarding_restaurant',
    ];
    const titles = [
      'Eat food from the best\nrestaurants',
      'Fast delivery of your\nfavorite food',
      'Find food restaurants\nnear you',
    ];
    const descriptions = [
      'Discover delicious dishes, freshly prepared\nand made with love. Your next favorite\nmeal is just a tap away.',
      'Fresh flavors, delivered to your door.\nEnjoy your favorites wherever you are,\nwithout the wait.',
      'Explore local favorites and find something\ndelicious around every corner.\nGood food is closer than you think.',
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 26),
          child: Column(
            children: [
              const Spacer(flex: 3),
              SizedBox(
                height: 200,
                child: Art(images[index], width: index == 0 ? 160 : 290),
              ),
              const SizedBox(height: 45),
              Text(
                titles[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                descriptions[index],
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted, fontSize: 15, height: 1.5),
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => GestureDetector(
                    onTap: () =>
                        Navigator.of(context)
                            .pushReplacementNamed('/0${i + 2}'),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      width: i == index ? 14 : 8,
                      height: i == index ? 14 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == index ? orange : const Color(0xFFDCDCDC),
                        border: i == index
                            ? Border.all(
                                color: const Color(0xFFFFBE8D),
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                'Next',
                onPressed: () =>
                    Navigator.of(context)
                        .pushReplacementNamed('/0${index + 3}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.signup = false});
  final bool signup;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(text: 'Chris Evans');
  final email = TextEditingController(text: 'chrisevans5478@gmail.com');
  final password = TextEditingController(text: 'eatko1234');
  final confirm = TextEditingController(text: 'eatko1234');
  bool hidden = true;
  @override
  void dispose() {
    for (final c in [name, email, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final s = StoreScope.of(context);
    s.name = name.text.trim();
    s.email = email.text.trim();
    s.update();
    go(context, widget.signup ? '/10' : '/09');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(38),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: widget.signup ? 125 : 270,
                    child: OverflowBox(
                      maxHeight: widget.signup ? 180 : 315,
                      alignment: Alignment.bottomCenter,
                      child: Art(
                        'auth_bowl',
                        height: widget.signup ? 180 : 315,
                        width: widget.signup ? 160 : 285,
                      ),
                    ),
                  ),
                  Tabs(
                    const ['Login', 'Sign up'],
                    widget.signup ? 1 : 0,
                    (i) =>
                        Navigator.of(context)
                            .pushReplacementNamed(i == 0 ? '/05' : '/06'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 38, 24, 24),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.signup)
                      LabeledField(
                        'User Name',
                        controller: name,
                        validator: requiredValue,
                        suffix: const Icon(Icons.check, size: 16, color: muted),
                      ),
                    LabeledField(
                      'Email Address',
                      controller: email,
                      keyboard: TextInputType.emailAddress,
                      validator: emailValidator,
                      suffix: const Icon(Icons.check, size: 16, color: muted),
                    ),
                    LabeledField(
                      'Password',
                      controller: password,
                      obscure: hidden,
                      validator: (v) => (v?.length ?? 0) >= 8
                          ? null
                          : 'Use at least 8 characters',
                      suffix: IconButton(
                        tooltip: 'Show password',
                        onPressed: () => setState(() => hidden = !hidden),
                        icon: Icon(
                          hidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: muted,
                        ),
                      ),
                    ),
                    if (widget.signup)
                      LabeledField(
                        'Confirm Password',
                        controller: confirm,
                        obscure: hidden,
                        validator: (v) =>
                            v == password.text ? null : 'Passwords must match',
                      ),
                    if (!widget.signup)
                      TextButton(
                        onPressed: () => go(context, '/07'),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          'Forgot password!',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    SizedBox(height: widget.signup ? 12 : 28),
                    PrimaryButton(
                      widget.signup ? 'Signup to app' : 'Sign in to app',
                      onPressed: submit,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.signup
                              ? 'Already have an account?'
                              : "Don't have an account?",
                          style: const TextStyle(fontSize: 12),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed(widget.signup ? '/05' : '/06'),
                          child: Text(
                            widget.signup ? 'Sign in' : 'Signup',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, this.phone = false});
  final bool phone;
  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final form = GlobalKey<FormState>();
  late final controller = TextEditingController(
    text: widget.phone ? '+00 1245 - 4578 -124' : 'chrisevans5478@gmail.com',
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: '',
    avatar: false,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Text(
                    'Recover your password',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Text(
                    'Enter your phone number or email',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                ),
                Tabs(
                  const ['Phone', 'Email'],
                  widget.phone ? 0 : 1,
                  (i) =>
                      Navigator.of(context)
                          .pushReplacementNamed(i == 0 ? '/08' : '/07'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Form(
              key: form,
              child: Column(
                children: [
                  LabeledField(
                    widget.phone ? 'Phone number' : 'Email Address',
                    controller: controller,
                    keyboard: widget.phone
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    validator: widget.phone ? phoneValidator : emailValidator,
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    'Submit',
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        toast(context, 'Demo verification code: 4973');
                        go(context, '/11', arguments: 'recovery');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        const Positioned.fill(child: MapArt()),
        SafeArea(
          child: Column(
            children: [
              const PageHeader('', avatar: true),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search location',
                    prefixIcon: Icon(Icons.search),
                    fillColor: pale,
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      StoreScope.of(context).city = value.trim();
                      StoreScope.of(context).update();
                      toast(context, 'Delivery area set to ${value.trim()}');
                    }
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 72),
                child: PrimaryButton(
                  'Enable location',
                  icon: Icons.location_on,
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (c) => Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Choose your delivery address',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Add an address to find food near you. This preview uses a sample delivery area.',
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            'Add address',
                            onPressed: () {
                              Navigator.of(c).pop();
                              go(context, '/18');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PrimaryButton(
                  'No, I will do it later',
                  onPressed: () => home(context),
                ),
              ),
              const SizedBox(height: 28),
              const BottomBar(),
            ],
          ),
        ),
      ],
    ),
  );
}

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final form = GlobalKey<FormState>();
  final phone = TextEditingController(text: '+1-202-555-0176');
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: '',
    avatar: false,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your phone',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            const Text(
              'Please enter your phone number and\nwe will send you a code.',
              style: TextStyle(color: muted, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 112),
            LabeledField(
              'Enter your phone number',
              controller: phone,
              keyboard: TextInputType.phone,
              validator: phoneValidator,
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              'Next',
              onPressed: () {
                if (form.currentState!.validate()) {
                  final s = StoreScope.of(context);
                  s.phone = phone.text;
                  s.update();
                  toast(context, 'Demo verification code: 4973');
                  go(context, '/11');
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});
  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final codes = List.generate(4, (i) => TextEditingController(text: '4973'[i]));
  @override
  void dispose() {
    for (final c in codes) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: '',
    avatar: false,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirmation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          const Text(
            'Please enter the verification code.\nUse 4973 to try this demo.',
            style: TextStyle(color: muted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 85),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (i) => SizedBox(
                width: 60,
                child: TextField(
                  controller: codes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 3) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 52),
          PrimaryButton(
            'Confirm',
            onPressed: () {
              if (codes.map((c) => c.text).join() != '4973') {
                toast(context, 'Incorrect code. Try 4973.');
                return;
              }
              FocusScope.of(context).unfocus();
              if (ModalRoute.of(context)?.settings.arguments == 'recovery') {
                toast(
                  context,
                  'Demo account recovered. You can sign in again.',
                );
                go(context, '/05');
              } else {
                go(context, '/12');
              }
            },
          ),
        ],
      ),
    ),
  );
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    title: '',
    avatar: false,
    background: Colors.white,
    bottom: PrimaryButton('Get started', onPressed: () => go(context, '/09')),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: canvas, width: 20),
            ),
            child: const Icon(
              Icons.thumb_up_alt_outlined,
              color: orange,
              size: 110,
            ),
          ),
          const SizedBox(height: 35),
          const Text(
            'Congratulations 😍',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
