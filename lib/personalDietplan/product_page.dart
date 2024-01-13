import 'package:flutter/material.dart';
import 'package:nutritionapp/personalDietplan/Meals.dart';
import 'package:nutritionapp/personalDietplan/custom_app_bar.dart';
import 'package:intl/intl.dart';


import 'custom_app_bar.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
  }

  updatePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: const CustomAppBar(title: "", uid: '',),
        backgroundColor: Colors.transparent,
        // body: TextButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/cart');
        //   },
        //   child: const Text("Ir para carrinho"),
        // ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              const Spacer(),
              Container(
                // height: 200, //removido o height e adicionado o Spacer
                margin: const EdgeInsets.all(16),
                child: CardDetail(
                  product: widget.product,
                  updatePage: updatePage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDetail extends StatefulWidget {
  final Product product;
  final Function updatePage;

  CardDetail({Key? key, required this.product, required this.updatePage})
      : super(key: key);

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  final formatReal = NumberFormat("###.00#cal", "en_US");

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCardDetail(
            text: widget.product.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          TextCardDetail(text: widget.product.description),
          Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(
                  formatReal.format(widget.product.calorie),
                  style: Theme.of(context).textTheme.headline1,
                ),
                ElevatedButton(
                  onPressed: () =>
                  {_addItemCart(ItemCart(product: widget.product, quantity: 1))},
                  child: const Text(
                    'Add to Plan',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _addItemCart(ItemCart item) {
    var items = Mealpage.itemsCart;
    int index = items.indexWhere((el) => el.product == widget.product);

    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(item);
    }
    debugPrint("👉 ${Mealpage.itemsCart.length}");
    widget.updatePage();
  }
}

class TextCardDetail extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const TextCardDetail({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  State<TextCardDetail> createState() => _TextCardDetailState();
}

class _TextCardDetailState extends State<TextCardDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      // child: Text(
      //   text,
      //   style: Theme.of(context).textTheme.headline1,
      // ),
      child: _textStyle(),
    );
  }

  _textStyle() {
    return widget.style == null ? Text(widget.text) : Text(widget.text, style: widget.style);
  }
}
