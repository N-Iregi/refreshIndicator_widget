import 'package:flutter/material.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshMart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A4F)),
        useMaterial3: true,
      ),
      home: const ShopHomePage(),
    );
  }
}

// Data model to define products

class Product {
  final String name;
  final String emoji;
  final double price;
  final int stock;

  const Product({
    required this.name,
    required this.emoji,
    required this.price,
    required this.stock,
  });
}

// Simulated inventory "batches" that rotate on each refresh
const List<List<Product>> _inventoryBatches = [
  [
    Product(name: 'Organic Apples', emoji: '🍎', price: 3.49, stock: 120),
    Product(name: 'Sourdough Bread', emoji: '🍞', price: 5.99, stock: 14),
    Product(name: 'Whole Milk', emoji: '🥛', price: 2.79, stock: 88),
    Product(name: 'Free-Range Eggs', emoji: '🥚', price: 4.49, stock: 60),
    Product(name: 'Cheddar Cheese', emoji: '🧀', price: 6.29, stock: 35),
    Product(name: 'Avocados', emoji: '🥑', price: 1.99, stock: 47),
  ],
  [
    Product(name: 'Greek Yoghurt', emoji: '🫙', price: 3.99, stock: 55),
    Product(name: 'Orange Juice', emoji: '🍊', price: 4.19, stock: 30),
    Product(name: 'Pasta (500 g)', emoji: '🍝', price: 1.89, stock: 200),
    Product(name: 'Tomato Sauce', emoji: '🍅', price: 2.49, stock: 75),
    Product(name: 'Chicken Breast', emoji: '🍗', price: 8.99, stock: 22),
    Product(name: 'Baby Spinach', emoji: '🥬', price: 3.29, stock: 18),
  ],
  [
    Product(name: 'Dark Chocolate', emoji: '🍫', price: 3.79, stock: 90),
    Product(name: 'Almond Butter', emoji: '🥜', price: 7.49, stock: 12),
    Product(name: 'Sparkling Water', emoji: '💧', price: 1.29, stock: 150),
    Product(name: 'Brown Rice (1 kg)', emoji: '🍚', price: 3.99, stock: 65),
    Product(name: 'Broccoli', emoji: '🥦', price: 2.19, stock: 40),
    Product(name: 'Salmon Fillet', emoji: '🐟', price: 11.99, stock: 8),
  ],
];

// Main screen

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  // State
  List<Product> _products = _inventoryBatches[0];
  int _batchIndex = 0;
  String _lastRefreshed = 'Just now';

  // Helpers

  Future<void> _refresh() async {

    // Simulate a 1.5-second network call
    await Future.delayed(const Duration(milliseconds: 1500));

    _batchIndex = (_batchIndex + 1) % _inventoryBatches.length;
    final now = TimeOfDay.now();

    setState(() {
      _products = _inventoryBatches[_batchIndex];
      _lastRefreshed =
          '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period.name.toUpperCase()}';
    });
  }

  // Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Text('🛒', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'FreshMart',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Updated: $_lastRefreshed',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),

      // RefreshIndicator wraps the product list and provides pull-to-refresh functionality
      body: RefreshIndicator(
        // PROPERTY 1 — color
        // Controls the colour of the spinning arc itself.
        color: const Color.fromARGB(255, 202, 29, 29),

        // PROPERTY 2 — backgroundColor
        // The circular background plate behind the spinner.
        backgroundColor: const Color.fromARGB(255, 6, 45, 219),

        // PROPERTY 3 — displacement
        // How many pixels below the top edge the indicator centres itself.
        displacement: 120.0,

        // The callback Flutter awaits before hiding the indicator.
        onRefresh: _refresh,

        child: _buildProductList(),
      ),
    );
  }

  Widget _buildProductList() {
    return CustomScrollView(
      slivers: [
        // Pull-to-refresh hint banner
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFD8F3DC),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.arrow_downward,
                    size: 14, color: Color(0xFF2D6A4F)),
                const SizedBox(width: 6),
                Text(
                  'Pull down to refresh inventory',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF2D6A4F).withOpacity(0.8),
                  ),
                ),
                const Spacer(),
                Text(
                  '${_products.length} items',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product grid
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCard(product: _products[index]),
              childCount: _products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
          ),
        ),
      ],
    );
  }
}

// Product card

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final lowStock = product.stock < 20;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji
            Center(
              child: Text(product.emoji,
                  style: const TextStyle(fontSize: 42)),
            ),
            const SizedBox(height: 10),

            // Name
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // Price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: lowStock
                        ? const Color(0xFFFFE8E8)
                        : const Color(0xFFD8F3DC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lowStock ? '⚠ ${product.stock} left' : '✓ In stock',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: lowStock
                          ? const Color(0xFFB00020)
                          : const Color(0xFF2D6A4F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
