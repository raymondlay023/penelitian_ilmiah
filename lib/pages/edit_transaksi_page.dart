import 'package:catet_kas/models/cart_model.dart';
import 'package:catet_kas/models/transaction_item_model.dart';
import 'package:catet_kas/models/transaction_model.dart';
import 'package:catet_kas/providers/cart_provider.dart';
import 'package:catet_kas/providers/transaction_provider.dart';
import 'package:catet_kas/theme.dart';
import 'package:catet_kas/widgets/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTransaksiPage extends StatefulWidget {
  final TransactionModel transaction;
  const EditTransaksiPage({required this.transaction});
  @override
  State<EditTransaksiPage> createState() => _EditTransaksiState();
}

class _EditTransaksiState extends State<EditTransaksiPage> {
  late double totalPrice;
  late String type = '';
  @override
  void initState() {
    super.initState();
    getCarts();
    totalPrice = getTotalPrice();
    type = getType();
  }

  getCarts() {
    CartProvider cartProvider = Provider.of(context, listen: false);
    List<TransactionItemModel> allItems = [];
    var items = widget.transaction.items!.map(
      (item) => item,
    );
    allItems.addAll(items.map((item) => TransactionItemModel.fromJson(item)));

    allItems.forEach((element) {
      cartProvider.carts.add(CartModel(
          id: element.id!,
          product: element.product!,
          quantity: element.quantity!));
    });
  }

  getTotalPrice() {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    return cartProvider.totalPrice();
  }

  getType() {
    return widget.transaction.type!;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController =
        TextEditingController(text: widget.transaction.note);
    TextEditingController totalPriceController =
        TextEditingController(text: totalPrice.toString());

    CartProvider cartProvider = Provider.of<CartProvider>(context);
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);

    List<CartModel> carts = cartProvider.carts;

    handleEditTransaction() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (await transactionProvider.update(
        id: widget.transaction.id!,
        token: token!,
        note: noteController.text,
        total: double.parse(totalPriceController.text),
        type: type,
        items: carts,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: pemasukanColor,
            content: const Text(
              'Transaksi berhasil dibuat!',
              textAlign: TextAlign.center,
            ),
          ),
        );
        setState(() {
          type = '';
          getTotalPrice();
          carts.clear();
        });
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: pengeluaranColor,
            content: const Text(
              'Transaksi gagal dibuat!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    Widget switchButton() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: defaultMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.55,
              height: 40,
              decoration: BoxDecoration(
                color:
                    type == 'PEMASUKAN' ? pemasukanColor : Colors.transparent,
                border: Border.all(
                  color: pemasukanColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                style: TextButton.styleFrom(primary: pemasukanColor),
                onPressed: () => setState(() {
                  type = 'PEMASUKAN';
                }),
                child: Text(
                  'Pemasukan',
                  style: secondaryTextStyle.copyWith(
                    color:
                        type == 'PEMASUKAN' ? backgroundColor1 : pemasukanColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 25),
            Container(
              width: MediaQuery.of(context).size.width / 2.55,
              height: 40,
              decoration: BoxDecoration(
                color: type == 'PENGELUARAN'
                    ? pengeluaranColor
                    : Colors.transparent,
                border: Border.all(
                  color: pengeluaranColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                style: TextButton.styleFrom(primary: pengeluaranColor),
                onPressed: () => setState(() {
                  type = 'PENGELUARAN';
                }),
                child: Text(
                  'Pengeluaran',
                  style: secondaryTextStyle.copyWith(
                    color: type == 'PENGELUARAN'
                        ? backgroundColor1
                        : pengeluaranColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonTambahBarangTransaksi() {
      return Container(
        width: 340,
        height: 40,
        margin: EdgeInsets.only(top: defaultMargin),
        decoration: BoxDecoration(
          border: Border.all(color: primaryTextColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextButton(
          style: TextButton.styleFrom(primary: primaryTextColor),
          onPressed: () {
            Navigator.pushNamed(context, '/product-list');
          },
          child: Text(
            '+ Tambah Barang Transaksi',
            style: secondaryTextStyle.copyWith(
              color: primaryTextColor,
            ),
          ),
        ),
      );
    }

    Widget inputTotalTransaksi() {
      return Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: defaultMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Transaksi',
              style: secondaryTextStyle.copyWith(
                color: primaryTextColor,
              ),
            ),
            const SizedBox(width: 60),
            Container(
              width: 160,
              height: 40,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                controller: totalPriceController,
                // onChanged: (String value) {
                //   setState(() {
                //     totalPrice = double.parse(value);
                //   });
                // },
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget inputCatatanTransaksi() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: noteController,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  label: const Text('Catatan Transaksi'),
                  floatingLabelStyle:
                      primaryTextStyle.copyWith(color: primaryTextColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryTextColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonSimpan() {
      return Container(
        width: MediaQuery.of(context).size.width / 1.1,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: defaultMargin),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          style: TextButton.styleFrom(primary: buttonColor),
          child: Text(
            'Simpan',
            style: secondaryTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
              color: primaryTextColor,
            ),
          ),
          onPressed: handleEditTransaction,
        ),
      );
    }

    Widget cartItems() {
      return Container(
        height: 250,
        margin: EdgeInsets.only(top: defaultMargin),
        child: ListView(
          shrinkWrap: true,
          children: carts.map((cart) => CartCard(cart: cart)).toList(),
        ),
      );
    }

    PreferredSizeWidget customAppBar() {
      return AppBar(
        toolbarHeight: 65,
        backgroundColor: primaryColor,
        title: Text(
          'Edit Transaksi',
          style: primaryTextStyle.copyWith(
            color: backgroundColor1,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            CartProvider cartProvider =
                Provider.of<CartProvider>(context, listen: false);
            cartProvider.carts.clear();
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          switchButton(),
          carts.isNotEmpty ? cartItems() : Container(),
          buttonTambahBarangTransaksi(),
          inputTotalTransaksi(),
          inputCatatanTransaksi(),
        ],
      ),
      bottomNavigationBar: buttonSimpan(),
    );
  }
}
