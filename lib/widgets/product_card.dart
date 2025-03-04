import 'package:catet_kas/models/product_model.dart';
import 'package:catet_kas/providers/cart_provider.dart';
import 'package:catet_kas/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  const ProductCard(this.product);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isChecked;
  @override
  void initState() {
    super.initState();
    isChecked = getData();
  }

  getData() {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    bool value = cartProvider.productExist(widget.product);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    _formatCurrency(double value) {
      return NumberFormat.currency(
              locale: 'id', decimalDigits: 0, symbol: 'Rp ')
          .format(value);
    }

    return GestureDetector(
      onTap: (() => isChecked = true),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Expanded(
          child: Row(
            children: [
              Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                      value == true
                          ? cartProvider.addCart(widget.product)
                          : cartProvider.removeCartByProduct(widget.product);
                    });
                  }),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name!,
                    style: secondaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                      color: primaryTextColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatCurrency(widget.product.price!),
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'Stok : ${widget.product.stock}',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
