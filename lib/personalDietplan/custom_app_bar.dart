
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritionapp/pages/home.dart';
import 'package:nutritionapp/personalDietplan/Meals.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCartPage;
  final bool showBackButton;
  final String uid;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.isCartPage = false,
    this.showBackButton = false, required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(this.uid),
            ),
          );// Navigate back to the previous screen
        },
      )
          : null,
      actions: [
        if (!isCartPage) const CartButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/cart');
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
        ),
        child: Stack(
          children: const [
            Image(
              height: 30,
              image: AssetImage('assets/icons/chartimage.png'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListCart extends StatefulWidget {
  final Function? updatePage;

  const ListCart({super.key, this.updatePage});

  @override
  State<ListCart> createState() => _ListCartState();
}

class _ListCartState extends State<ListCart> {
  final List<ItemCart> cart = Mealpage.itemsCart;
  final formatReal = NumberFormat("###.00#cal", "en_US");

  // ItemsCart({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (BuildContext context, int indice) {
        ItemCart item = cart[indice];

        return Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(item.product.imageUrl),
                    height: 92,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.title,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatReal.format(item.product.calorie)),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _incrementItem(item),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    child: const Icon(Icons.add_circle, size: 18),
                                  ),
                                ),
                                Text('${item.quantity}'),
                                InkWell(
                                  onTap: () => _decrementItem(item),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    child: const Icon(Icons.remove_circle, size: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _incrementItem(ItemCart item) {
    setState(() {
      item.quantity++;
      widget.updatePage != null ? widget.updatePage!() : null;
    });
  }

  void _decrementItem(ItemCart item) {
    setState(() {
      item.quantity > 1 ? item.quantity-- : Mealpage.itemsCart.remove(item);
      widget.updatePage != null ? widget.updatePage!() : null;
    });
  }
}

