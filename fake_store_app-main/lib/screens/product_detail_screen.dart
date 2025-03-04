import 'package:fake_store_app/providers/cart_provider.dart';
import 'package:fake_store_app/services/api.service.dart';
import 'package:fake_store_app/widgets/quantity_selector.dart';
import 'package:fake_store_app/widgets/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../widgets/shopping_cart.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> product;

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    product = ApiService().getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세'), actions: [ShoppingCart()]),
      body: SafeArea(
        child: FutureBuilder(
          future: product,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('에러가 발생'));
            }
            return Column(
              children: [
                Expanded(child: _buildProductDetail(snapshot.data as Product)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final cartProvider = context.read<CartProvider>();
                        cartProvider.addToCart(
                          snapshot.data as Product,
                          quantity: quantity,
                        );
                      },
                      child: Text(
                        '장바구니에 담기',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail(Product data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              data.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.contain,
            ),
            Text(
              data.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Row(
              children: [
                Spacer(),
                SizedBox(width: 90),
                Text(
                  '\$${data.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),

                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text(
                  '${data.rating['rate']} (${data.rating['count']})',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),

            SizedBox(height: 8),
            Text(data.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),

            SizedBox(height: 15),
            QuantitySelector(
              onQuantityChange: (quantity) {
                setState(() {
                  this.quantity = quantity;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
