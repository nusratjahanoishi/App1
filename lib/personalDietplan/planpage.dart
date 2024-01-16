import 'package:nutritionapp/personalDietplan/Meals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_app_bar.dart';


class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final formatReal = NumberFormat("###.00#cal", "en_US");

  @override
  Widget build(BuildContext context) {
    int valorTotal = _calculateTotal();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Meals",
        isCartPage: true, uid: '',
      ),
      body: _buildListItems(),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Calorie',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              formatReal.format(valorTotal),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],),
      ),
    );
  }

  void updatePage() {
    setState(() {});
  }

  int _calculateTotal() {
    if (Mealpage.itemsCart.isNotEmpty) {
      return Mealpage.itemsCart
          .map((item) => item.product.calorie * item.quantity)
          .reduce((precoAtual, precoNovo) => precoAtual + precoNovo);
    }

    return 0;
  }

  Widget _buildListItems() {
    if (Mealpage.itemsCart.isNotEmpty) {
      return ListCart(
        updatePage: updatePage,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: double.infinity,
        child: const Text('Add a meal plan', style: TextStyle(
          fontSize: 16,
        ),),
      );
    }
  }
}
class CartButton extends StatefulWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        Navigator.pushNamed(context, '/cart')
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 30,
          left: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            topLeft: Radius.circular(100),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 5,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: Stack(
          children: const [
            Image(
              height: 30,
              image: AssetImage('assets/icons/'),
            ),

          ],
        ),
      ),
    );
  }
}