import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key, this.selected, required this.onSelected});
  final String? selected;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (c, i) {
        const labels = ['Vegetables', 'Fast Food', 'Ice Cream'];
        const images = ['vegetables', 'fast_food', 'ice_cream'];
        const colors = [
          Color(0xFFFCE9DE),
          Color(0xFFFAF1DB),
          Color(0xFFFBE9EC),
        ];
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onSelected(labels[i]),
          child: Container(
            width: 113,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: colors[i],
              borderRadius: BorderRadius.circular(10),
              border: selected == labels[i] ? Border.all(color: orange) : null,
            ),
            child: Row(
              children: [
                Art(images[i], width: 34, height: 40),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.onChanged,
    this.onTap,
    this.controller,
    this.hint = 'Search',
  });
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String hint;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    readOnly: onTap != null,
    onTap: onTap,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9898A7),
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      prefixIcon: const Icon(Icons.search, color: Color(0xFF9898A7)),
      fillColor: pale,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

class FoodTile extends StatelessWidget {
  const FoodTile(this.food, {super.key, this.large = false});
  final Food food;
  final bool large;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return SizedBox(
      width: large ? 164 : 156,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 18,
            child: GestureDetector(
              onTap: () => go(context, '/14', arguments: food),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 13, 10, 22),
                decoration: BoxDecoration(
                  color: canvas,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 26,
                      offset: const Offset(0, 24),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(child: Art(food.image, width: large ? 146 : 125)),
                    const SizedBox(height: 10),
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: large ? 19 : 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      food.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9, color: muted),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      money(food.price),
                      style: const TextStyle(
                        color: orange,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              tooltip: 'Favorite ${food.name}',
              onPressed: () => store.favorite(food.id),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: store.favorites.contains(food.id)
                      ? orange
                      : const Color(0xFFB9B9BE),
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: ink),
                  tooltip: 'View ${food.name}',
                  onPressed: () => go(context, '/14', arguments: food),
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final carousel = PageController(initialPage: 1, viewportFraction: .53);
  @override
  void dispose() {
    carousel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Home',
    menu: true,
    navigation: true,
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Row(
            children: [
              Expanded(child: SearchBox(onTap: () => go(context, '/15'))),
              const SizedBox(width: 34),
              SizedBox(
                width: 55,
                height: 55,
                child: IconButton.filled(
                  onPressed: () => go(context, '/17'),
                  tooltip: 'Food filter',
                  style: IconButton.styleFrom(
                    backgroundColor: orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        CategoryBar(
          onSelected: (category) => go(context, '/15', arguments: category),
        ),
        const SizedBox(height: 36),
        SizedBox(
          height: 285,
          child: PageView.builder(
            controller: carousel,
            clipBehavior: Clip.none,
            itemCount: 4,
            itemBuilder: (c, i) => AnimatedBuilder(
              animation: carousel,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: FoodTile(foods[[1, 0, 2, 3][i]], large: true),
              ),
              builder: (c, child) {
                final page =
                    carousel.hasClients &&
                        carousel.position.hasContentDimensions
                    ? carousel.page ?? 1
                    : 1;
                return Transform.scale(
                  scale: 1 - ((page - i).abs().clamp(0, 1) * .18),
                  child: child,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 18, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => go(context, '/15'),
                child: const Text(
                  'View all items',
                  style: TextStyle(fontSize: 12, color: orange),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (c, i) {
              final f = foods[i + 4];
              return InkWell(
                onTap: () => go(context, '/14', arguments: f),
                child: SizedBox(
                  width: 127,
                  child: Surface(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Art(f.image, width: 48, height: 48),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.name,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                money(f.price),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
      ],
    ),
  );
}

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key, required this.food});
  final Food food;
  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = StoreScope.of(context);
    if (!store.viewed.contains(widget.food.id)) {
      store.viewed.add(widget.food.id);
      WidgetsBinding.instance.addPostFrameCallback((_) => store.update());
    }
  }

  int quantity = 1;
  String size = 'M';
  int get unitPrice =>
      widget.food.price +
      (size == 'L'
          ? 200
          : size == 'S'
          ? -100
          : 0);
  @override
  Widget build(BuildContext context) {
    final f = widget.food;
    final s = StoreScope.of(context);
    return AppPage(
      title: 'Food',
      trailing: const BagButton(),
      bottom: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: IconButton.filled(
              tooltip: 'Favorite ${f.name}',
              style: IconButton.styleFrom(
                backgroundColor: orange,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: () => s.favorite(f.id),
              icon: Icon(
                s.favorites.contains(f.id)
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: PrimaryButton(
              'Add to cart',
              onPressed: () {
                s.add(f, size, quantity);
                toast(context, '$quantity × ${f.name} added to cart');
              },
            ),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SizedBox(
            height: 235,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (f.id == 'salad') ...[
                  const Positioned.fill(
                    child: Art('food_herbs', fit: BoxFit.fill),
                  ),
                  const Positioned(
                    left: -24,
                    top: 0,
                    bottom: 0,
                    child: Art('food_leaves', width: 150),
                  ),
                ],
                Art(f.image, height: 218),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 190,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Decrease quantity',
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Increase quantity',
                    onPressed: quantity < 99
                        ? () => setState(() => quantity++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  f.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const Text(
                    '★ (4.0)',
                    style: TextStyle(
                      color: orange,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => go(context, '/24'),
                    child: const Text(
                      'View all reviews',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: ['S', 'M', 'L']
                .map(
                  (v) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            v,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: size == v ? Colors.white : ink,
                            ),
                          ),
                        ),
                        selected: size == v,
                        showCheckmark: false,
                        selectedColor: orange,
                        backgroundColor: const Color(0xFFFCE9DE),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        onSelected: (_) => setState(() => size = v),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 22),
          Text(
            money(unitPrice * quantity),
            style: const TextStyle(
              fontSize: 32,
              color: orange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Description',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            '${f.description}. Prepared fresh with carefully selected ingredients, balanced flavors and our signature seasoning. Choose your portion and enjoy a delicious meal, delivered to your door.',
            style: const TextStyle(color: muted, height: 1.5, fontSize: 14),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.favoritesOnly = false});
  final bool favoritesOnly;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '', category = '', location = '', filterBy = '';
  int? maxPrice, minPrice;
  bool viewedOnly = false;
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg == 'viewed') viewedOnly = true;
      if (arg is String && arg != 'favorites' && arg != 'viewed') {
        category = arg;
      }
      if (arg is Map) {
        category = arg['category'] as String? ?? '';
        maxPrice = arg['maxPrice'] as int?;
        minPrice = arg['minPrice'] as int?;
        location = arg['location'] as String? ?? '';
        filterBy = arg['by'] as String? ?? '';
      }
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    final filtered = foods
        .where(
          (f) =>
              (!widget.favoritesOnly || s.favorites.contains(f.id)) &&
              (!viewedOnly || s.viewed.contains(f.id)) &&
              (location.isEmpty || location == 'Bristol') &&
              (filterBy != 'Preferred' || s.favorites.contains(f.id)) &&
              (filterBy != 'Side dish' || ['soup', 'hummus'].contains(f.id)) &&
              (filterBy != 'Juice') &&
              (filterBy != 'Ordered' || s.hasOrder) &&
              (category.isEmpty || f.category == category) &&
              (minPrice == null || f.price >= minPrice!) &&
              (maxPrice == null || f.price <= maxPrice!) &&
              '${f.name} ${f.description}'.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return AppPage(
      title: widget.favoritesOnly
          ? 'Wish List'
          : viewedOnly
          ? 'Recently viewed'
          : 'Search Food',
      navigation: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
            child: SearchBox(
              hint: 'Healthy food item',
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  'Found ${filtered.length} items',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (category.isNotEmpty ||
                    maxPrice != null ||
                    location.isNotEmpty ||
                    filterBy.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() {
                      category = '';
                      maxPrice = null;
                      minPrice = null;
                      location = '';
                      filterBy = '';
                    }),
                    child: const Text(
                      'Clear filters',
                      style: TextStyle(color: orange),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    'No dishes found',
                    'Try another search or clear your filters.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 34,
                          crossAxisSpacing: 24,
                          mainAxisExtent: 253,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (c, i) => FoodTile(filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String category = '', location = 'Bristol', by = 'Food', price = '\$5 – \$20';
  Widget chips(
    String heading,
    List<String> values,
    String selected,
    ValueChanged<String> change,
  ) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: values
              .map(
                (v) => SizedBox(
                  width: 96,
                  child: ChoiceChip(
                    label: Center(
                      child: Text(
                        v,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected == v ? Colors.white : muted,
                        ),
                      ),
                    ),
                    selected: selected == v,
                    selectedColor: orange,
                    backgroundColor: pale,
                    showCheckmark: false,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    onSelected: (_) => setState(() => change(v)),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Food Filter',
    close: true,
    avatar: false,
    trailing: const Icon(Icons.search),
    bottom: PrimaryButton(
      'Apply',
      onPressed: () => go(
        context,
        '/15',
        arguments: {
          'category': category,
          'location': location,
          'by': by,
          'minPrice': price.isEmpty
              ? null
              : price == '\$5 – \$20'
              ? 500
              : price == '\$20 – \$50'
              ? 2000
              : 5000,
          'maxPrice': price.isEmpty
              ? null
              : price == '\$5 – \$20'
              ? 2000
              : price == '\$20 – \$50'
              ? 5000
              : 10000,
        },
      ),
    ),
    child: ListView(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => setState(() {
              category = '';
              location = '';
              by = '';
              price = '';
            }),
            child: const Text(
              'Clear all',
              style: TextStyle(color: orange, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        CategoryBar(
          selected: category,
          onSelected: (v) => setState(() => category = category == v ? '' : v),
        ),
        chips(
          'Locations',
          ['Franklin', 'Arlington', 'Lebanon', 'Clinton', 'Bristol', 'Dayton'],
          location,
          (v) => location = v,
        ),
        chips(
          'Filter by',
          ['Ordered', 'Open', 'Side dish', 'Food', 'Preferred', 'Juice'],
          by,
          (v) => by = v,
        ),
        chips(
          'Price',
          ['\$5 – \$20', '\$20 – \$50', '\$50 – \$100'],
          price,
          (v) => price = v,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(
            'Showing dishes from the sample Bristol menu.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ),
      ],
    ),
  );
}
