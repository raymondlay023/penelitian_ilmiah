import 'package:catet_kas/models/product_model.dart';
import 'package:catet_kas/providers/product_provider.dart';
import 'package:catet_kas/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductPage extends StatelessWidget {
  final ProductModel product;
  const EditProductPage({required this.product});
  // const EditProductPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    // ProductModel product = productProvider.product;

    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController capitalController =
        TextEditingController(text: product.capital.toString());
    TextEditingController stockController =
        TextEditingController(text: product.stock.toString());

    handleUpdateProduct() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (await productProvider.update(
        token: token!,
        id: product.id!,
        name: nameController.text,
        price: double.parse(priceController.text),
        capital: double.parse(capitalController.text),
        stock: int.parse(stockController.text),
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              'Produk berhasil diupdate!',
              textAlign: TextAlign.center,
              style: secondaryTextStyle.copyWith(
                color: backgroundColor1,
              ),
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
            context, '/product-list', ModalRoute.withName('/add-transaction'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Produk gagal diupdate!',
              textAlign: TextAlign.center,
              style: secondaryTextStyle.copyWith(
                color: backgroundColor1,
              ),
            ),
          ),
        );
      }
    }

    Widget inputNamaBarang() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: nameController,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                floatingLabelStyle: secondaryTextStyle.copyWith(
                  color: primaryColor,
                ),
                label: const Text('Nama Barang'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: thirdTextColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget inputHargaJual() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: priceController,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                floatingLabelStyle: secondaryTextStyle.copyWith(
                  color: primaryColor,
                ),
                label: const Text('Harga Jual'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: thirdTextColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget inputModal() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: capitalController,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                floatingLabelStyle: secondaryTextStyle.copyWith(
                  color: primaryColor,
                ),
                label: const Text('Modal'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: thirdTextColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget inputStokBarang() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: stockController,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                floatingLabelStyle: secondaryTextStyle.copyWith(
                  color: primaryColor,
                ),
                label: const Text('Stok Barang'),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: thirdTextColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget buttonSimpan() {
      return Container(
        width: 300,
        height: 47,
        margin: EdgeInsets.only(bottom: defaultMargin),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          child: Text(
            'Simpan',
            style: secondaryTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
              color: primaryTextColor,
            ),
          ),
          onPressed: handleUpdateProduct,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: primaryColor,
        title: Text(
          'Edit Barang',
          style: primaryTextStyle.copyWith(
            color: backgroundColor1,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            inputNamaBarang(),
            const SizedBox(height: 20),
            inputHargaJual(),
            const SizedBox(height: 20),
            inputModal(),
            const SizedBox(height: 20),
            inputStokBarang(),
            const Spacer(),
            buttonSimpan(),
          ],
        ),
      ),
    );
  }
}
