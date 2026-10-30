import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';
import '../../shared/map_art.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.previous = false});
  final bool previous;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int tab = widget.previous ? 1 : 0;
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'Cart food',
      trailing: const BagButton(),
      child: Column(
        children: [
          Tabs(
            const ['Active', 'Previous'],
            tab,
            (v) => setState(() => tab = v),
          ),
          if (tab == 0) ...[
            Expanded(
              child: s.cart.isEmpty
                  ? const EmptyState(
                      'Your cart is empty',
                      'Explore the menu to add your favorite dishes.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 36, 24, 22),
                      itemCount: s.cart.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 26),
                      itemBuilder: (c, i) {
                        final line = s.cart[i];
                        return Surface(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    go(context, '/14', arguments: line.food),
                                child: Art(
                                  line.food.image,
                                  width: 96,
                                  height: 100,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.food.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      '${line.size} · ${line.food.description}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: muted,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      money(line.unitPrice * line.quantity),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 32,
                                decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        tooltip: 'Remove ${line.food.name}',
                                        onPressed: () => s.change(line, -1),
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${line.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        tooltip: 'Add ${line.food.name}',
                                        onPressed: () => s.change(line, 1),
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  summaryRow('Items', '${s.count}'),
                  summaryRow('Subtotal', money(s.subtotal)),
                  summaryRow('Delivery charge', money(s.delivery)),
                  summaryRow('Total', money(s.total), highlight: true),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    'Checkout',
                    onPressed: s.cart.isEmpty
                        ? null
                        : () => go(context, '/18', arguments: 'checkout'),
                  ),
                ],
              ),
            ),
          ] else
            Expanded(
              child: s.hasOrder
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Surface(
                            child: Column(
                              children: [
                                const ListTile(
                                  leading: Icon(
                                    Icons.delivery_dining,
                                    color: orange,
                                  ),
                                  title: Text('Your latest order'),
                                  subtitle: Text('Preparing · 20–25 min'),
                                ),
                                summaryRow(
                                  'Total paid (demo)',
                                  money(s.lastTotal),
                                ),
                                const SizedBox(height: 12),
                                PrimaryButton(
                                  'Track order',
                                  onPressed: () => go(context, '/22'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const EmptyState(
                      'No previous orders',
                      'Your completed demo orders will appear here.',
                    ),
            ),
        ],
      ),
    );
  }
}

Widget summaryRow(String label, String value, {bool highlight = false}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: highlight ? 20 : 15,
              color: highlight ? orange : ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: highlight ? 22 : 15,
              color: highlight ? orange : ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      phone = TextEditingController(),
      city = TextEditingController(),
      street = TextEditingController();
  bool initialized = false, save = true;
  int tab = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final s = StoreScope.of(context);
      name.text = s.name;
      phone.text = s.phone;
      city.text = s.city;
      street.text = s.street;
      tab = s.addressType == 'Home' ? 0 : 1;
      save = s.saveAddress;
      initialized = true;
    }
  }

  @override
  void dispose() {
    for (final c in [name, phone, city, street]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Add address',
    menu: true,
    bottom: PrimaryButton(
      'Add',
      onPressed: () {
        if (!form.currentState!.validate()) return;
        final s = StoreScope.of(context);
        s.name = name.text.trim();
        s.phone = phone.text.trim();
        s.city = city.text.trim();
        s.street = street.text.trim();
        s.addressType = tab == 0 ? 'Home' : 'Office';
        s.saveAddress = save;
        s.update();
        go(
          context,
          '/19',
          arguments: ModalRoute.of(context)?.settings.arguments,
        );
      },
    ),
    child: Column(
      children: [
        Tabs(const ['Home', 'Office'], tab, (v) => setState(() => tab = v)),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 46, 24, 20),
            child: Form(
              key: form,
              child: Column(
                children: [
                  LabeledField(
                    'Your Name',
                    controller: name,
                    validator: requiredValue,
                    underline: true,
                  ),
                  LabeledField(
                    'Phone number',
                    controller: phone,
                    validator: phoneValidator,
                    keyboard: TextInputType.phone,
                    underline: true,
                  ),
                  LabeledField(
                    'City',
                    controller: city,
                    validator: requiredValue,
                    underline: true,
                  ),
                  LabeledField(
                    'Street address',
                    controller: street,
                    validator: requiredValue,
                    underline: true,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Save your address information',
                      style: TextStyle(fontSize: 15),
                    ),
                    activeThumbColor: orange,
                    value: save,
                    onChanged: (v) => setState(() => save = v),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class AddressSummaryScreen extends StatelessWidget {
  const AddressSummaryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    Widget entry(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
    return AppPage(
      title: 'Your address',
      menu: true,
      bottom: PrimaryButton(
        'Save',
        onPressed: () {
          if (ModalRoute.of(context)?.settings.arguments != 'checkout') {
            home(context);
            toast(context, 'Address saved');
          } else {
            go(context, '/20');
          }
        },
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Delivery address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                entry('Your Name', s.name),
                entry('Phone number', s.phone),
                entry('City', s.city),
                entry('${s.addressType} · Street address', s.street),
                TextButton.icon(
                  onPressed: () => go(
                    context,
                    '/18',
                    arguments: ModalRoute.of(context)?.settings.arguments,
                  ),
                  icon: const Icon(Icons.edit, color: orange, size: 18),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selected = 'Credit Card';
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Payment method',
    bottom: PrimaryButton(
      'Add',
      onPressed: () {
        StoreScope.of(context).payment = selected;
        if (selected == 'Credit Card') {
          go(context, '/21');
        } else {
          showDialog<void>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text('$selected · Demo checkout'),
              content: const Text(
                'This is a local preview. No charge will be made.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(c).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(c).pop();
                    completeDemoOrder(context);
                  },
                  child: const Text('Place demo order'),
                ),
              ],
            ),
          );
        }
      },
    ),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
      children: [
        const Text(
          'Select your payment method.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 34),
        const Text(
          'Add a new credit/debit card',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        ...List.generate(5, (i) {
          const methods = [
            'Paypal',
            'Credit Card',
            'Apple pay',
            'Google pay',
            'WebMoney',
          ];
          const icons = [
            Icons.paypal,
            Icons.credit_card,
            Icons.apple,
            Icons.g_mobiledata,
            Icons.public,
          ];
          const colors = [
            Color(0xFF084EA5),
            orange,
            Colors.black,
            Color(0xFF4285F4),
            Color(0xFF1D91D1),
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i == 4)
                const Padding(
                  padding: EdgeInsets.only(top: 28, bottom: 12),
                  child: Text(
                    'WebMoney',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: 78,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Icon(icons[i], color: colors[i], size: 30),
                ),
                title: Text(methods[i], style: const TextStyle(fontSize: 16)),
                trailing: Icon(
                  selected == methods[i]
                      ? Icons.radio_button_checked
                      : Icons.circle,
                  size: 16,
                  color: selected == methods[i]
                      ? orange
                      : const Color(0xFFDADADA),
                ),
                onTap: () => setState(() => selected = methods[i]),
              ),
            ],
          );
        }),
      ],
    ),
  );
}

void completeDemoOrder(BuildContext context) {
  final s = StoreScope.of(context);
  if (s.cart.isEmpty) {
    toast(context, 'Add a dish to your cart first');
    return;
  }
  s.checkout();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/22', (r) => r.settings.name == '/13');
}

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});
  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(text: 'Chris Evans'),
      number = TextEditingController(text: '4242 4242 4242 4242'),
      cvv = TextEditingController(),
      expiry = TextEditingController();
  @override
  void dispose() {
    for (final c in [name, number, cvv, expiry]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return AppPage(
      title: 'My card',
      bottom: PrimaryButton(
        'Pay ${money(s.total)}',
        onPressed: () {
          if (!form.currentState!.validate()) return;
          showDialog<void>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Place demo order?'),
              content: Text(
                '${money(s.total)} · No real payment will be processed.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(c).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(c).pop();
                    completeDemoOrder(context);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        },
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: form,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 190,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB827), orange],
                    stops: [.05, .7],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '••••   ••••   ••••   4242',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    const Spacer(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Demo payment card',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Icon(Icons.credit_card, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38),
              LabeledField(
                'Cardholder',
                controller: name,
                validator: requiredValue,
              ),
              LabeledField(
                'Card number',
                controller: number,
                keyboard: TextInputType.number,
                validator: (v) =>
                    (v ?? '').replaceAll(RegExp(r'\D'), '').length == 16
                    ? null
                    : 'Enter 16 digits',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LabeledField(
                      'CVV',
                      controller: cvv,
                      obscure: true,
                      keyboard: TextInputType.number,
                      maxLength: 3,
                      validator: (v) => RegExp(r'^\d{3}$').hasMatch(v ?? '')
                          ? null
                          : '3 digits',
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 2,
                    child: LabeledField(
                      'Expiry (MM/YY)',
                      controller: expiry,
                      keyboard: TextInputType.datetime,
                      maxLength: 5,
                      validator: (v) {
                        if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$')
                            .hasMatch(v ?? '')) {
                          return 'Use MM/YY';
                        }
                        final parts = v!.split('/');
                        final now = DateTime.now();
                        return DateTime(
                              2000 + int.parse(parts[1]),
                              int.parse(parts[0]) + 1,
                            ).isAfter(now)
                            ? null
                            : 'Card has expired';
                      },
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Remember payment preference',
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: const Text(
                  'Card details are never stored',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                activeThumbColor: orange,
                value: s.rememberPayment,
                onChanged: (v) {
                  s.rememberPayment = v;
                  s.update();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MapArt(tracking: true)),
          SafeArea(
            child: Column(
              children: [
                const PageHeader('Track order'),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .15),
                          blurRadius: 24,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Avatar(size: 54, courier: true),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Manuel C. Smith',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Food courier',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Contact courier',
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: const Text('Contact courier'),
                                  content: const Text(
                                    'Demo courier · +1 202 555 0124\nCalling is unavailable in this local preview.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                          const ClipboardData(
                                            text: '+1 202 555 0124',
                                          ),
                                        );
                                        Navigator.of(c).pop();
                                        toast(context, 'Number copied');
                                      },
                                      child: const Text('Copy number'),
                                    ),
                                  ],
                                ),
                              ),
                              icon: const Icon(
                                Icons.phone_in_talk,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            const Icon(
                              Icons.map_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                s.street,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              '20–25 min',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => go(context, '/24'),
                          child: const Text(
                            'Review your delivery →',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
