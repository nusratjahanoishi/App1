import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:nutritionapp/personalDietplan/custom_app_bar.dart';
import 'package:nutritionapp/personalDietplan/product_page.dart';

import 'custom_app_bar.dart';


class Mealpage extends StatefulWidget {
  static List<ItemCart> itemsCart = [];

  Mealpage({Key? key}) : super(key: key);

  @override
  State<Mealpage> createState() => _MealpageState();
}

class _MealpageState extends State<Mealpage> {
  final List products = [
    {
      "title": " Grilled Chicken Caesar Salad",
      "calorie": 350,
      "image": "Grilled Chicken Caesar Salad.jpeg",
      "description":
          "Classic Caesar salad gets a flavor facelift thanks to the grill! Romaine hearts, rosemary marinated chicken and even the bread for the croutons are all grilled to perfection in this healthy Grilled Chicken Caesar Salad!"
    },
    {
      "title": "Quinoa and Avocado Power Salad",
      "calorie": 400,
      "image": "Quinoa and Avocado Power Salad.jpeg",
      "description":
          "With protein-packed quinoa, creamy avocado, grape tomatoes, and crisp cucumbers, this Quinoa Avocado Salad will quickly become a lunchtime staple! A zippy red wine vinaigrette brings it all together, adding lots of flavor while still keeping things light."
    },
    {
      "title": "Mediterranean Chickpea Salad",
      "calorie": 300,
      "image": "Mediterranean Chickpea Salad.jpeg",
      "description":
          "Whether we’re craving fresh veggies and flavors or simply can’t be bothered to turn on the oven, refreshing summer salads are our go-to all season long. But, when we’re hungry for more than a light side, sometimes we need to bulk things up, just like we do in this Mediterranean chickpea salad.."
    },
    {
      "title": "Asian Sesame Ginger Tofu Salad",
      "calorie": 250,
      "image": "Asian Sesame Ginger Tofu Salad.jpeg",
      "description":
          "This Ginger Sesame Tofu Chopped Salad is inspired by the salads that you may find at some American Japanese Restaurants. I’ve always have loved that fresh carrot and gingery zing.  It’s easily adaptable to suit your taste buds. "
    },
    {
      "title": "Honey Pancakes",
      "calorie": 300,
      "image": "Honey Pancakes.jpeg",
      "description":
          "Breakfast was my favorite meal of the day growing up, and pancakes were always my breakfast of choice! Nowadays, I'm more of a brunch person, but I still love pancakes (especially with a honey latte)!"
    },
    {
      "title": "Protein-Packed Breakfast Toast",
      "calorie": 350,
      "image": "Protein-Packed Breakfast Toast.jpeg",
      "description":
          "Cottage cheese peach toast is the perfect 5 minute summer breakfast. Crispy bread loaded with protein packed cottage cheese, fresh juicy peaches and drizzled with hot honey. Fresh and flavourful!"
    },
    {
      "title": "Vegetable and Egg Wrap for Lunch",
      "calorie": 400,
      "image": "Vegetable and Egg Wrap for Lunch.jpg",
      "description":
          "Fresh vegetables add crunch and flavor to plain egg salad in this recipe. These low-calorie wraps are perfect for a casual lunch gathering for friends or for taking on a picnic. Just wrap each one tightly in wax paper and then plastic wrap"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Personal Diet Plan",
        showBackButton: true, uid: ''
        ,

      ),
      body: Column(
        children: [
          const RowDivisor(title: "Meal"),
          Flexible(
            child: ViewProducts(
              products: products,
            ),
          ),
        ],
      ),
    );
  }
}
class ItemCart {
  final Product product;
  int quantity;

  ItemCart({required this.product, required this.quantity});
}

class Product {
  late String title;
  late String image;
  late String description;
  late int calorie;

  Product({
    required this.title,
    required this.image,
    required this.description,
    required this.calorie,
  });

  // Product.fromJson2(Map<String, dynamic> json) {
  //   title = json['title'] ?? '';
  //   image = json['image'] ?? '';
  //   description = json['description'] ?? '';
  //   calorie = json['calorie']?.toInt() ?? 0;
  // }
  get imageUrl => 'assets/images/$image';

  Product copyWith({
    String? title,
    String? image,
    String? description,
    int? calorie,
  }) {
    return Product(
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      calorie: calorie ?? this.calorie,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'description': description,
      'calorie': calorie,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      calorie: map['calorie']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(title: $title, image: $image, description: $description, calorie: $calorie)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.title == title &&
        other.image == image &&
        other.description == description &&
        other.calorie == calorie;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    image.hashCode ^
    description.hashCode ^
    calorie.hashCode;
  }
}

class RowDivisor extends StatefulWidget {
  final String title;

  const RowDivisor({Key? key, required this.title}) : super(key: key);

  @override
  State<RowDivisor> createState() => _RowDivisorState();
}

class _RowDivisorState extends State<RowDivisor> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(
            left: 30,
            // top: 10,
            right: 30,
            // bottom: 10,
          ),
          child: const Divider(),
        ),
      ),
      Text(widget.title),
      Expanded(
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(
            left: 30,
            top: 10,
            right: 30,
            bottom: 10,
          ),
          child: const Divider(),
        ),
      ),
    ]);
  }
}

class ViewProducts extends StatefulWidget {
  final List products;

  const ViewProducts({Key? key, required this.products}) : super(key: key);

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // childAspectRatio: 1.0,
        // crossAxisSpacing: 5.0,
        // mainAxisSpacing: 5.0,
      ),
      itemCount: widget.products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = Product.fromMap(widget.products[index]);

        return TileProduct(
          product: product,
        );
      },
    );
  }
}
class TileProduct extends StatefulWidget {
  final Product product;

  const TileProduct({Key? key, required this.product}) : super(key: key);

  @override
  State<TileProduct> createState() => _TileProductState();
}

class _TileProductState extends State<TileProduct> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.white24,
    //   child: Text(product.title),
    // );
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, '/product', arguments: product);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: widget.product),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 8.0,
              color: Colors.black12,
            ),
          ],
        ),
        margin: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/${widget.product.image}'),
                ),
              ),
              const GradientContainer(),
              Positioned(
                bottom: 10,
                child: Text(widget.product.title, style: Theme.of(context).textTheme.headline2,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class GradientContainer extends StatefulWidget {
  final Color? secondaryColor;

  const GradientContainer({
    Key? key,
    this.secondaryColor,
  }) : super(key: key);

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            // Color.fromRGBO(178, 155, 178, 0.9)
            widget.secondaryColor?? Theme.of(context).primaryColor,
          ],
        ),
      ),
    );
  }
}


