import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:foode_waste_app_1/models/cart_item.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class Restaurant extends ChangeNotifier {
  // list of food menu
  final List<Food> _menu = [
    // burgers
    Food(
      name: 'Classic Beef Burger',
      description:
      "Delicious Burger with cheese, lettuce, and juicy beef patty.",
      imagePath: "lib/images/burgers/burger.jpg",
      price: 4.50,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Classic Cheese Burger',
      description:
      "Delicious Burger with cheese, lettuce, and juicy beef patty.",
      imagePath: "lib/images/burgers/burger1.jpeg",
      price: 4.50,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Classic Burger',
      description:
      "Delicious Burger with cheese, lettuce, and juicy beef patty.",
      imagePath: "lib/images/burgers/burger2.jpeg",
      price: 4.50,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Beef Burger',
      description:
      "Delicious Burger with cheese, lettuce, and juicy beef patty.",
      imagePath: "lib/images/burgers/burger3.jpeg",
      price: 4.50,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Cheese Burger',
      description:
      "Delicious Burger with cheese, lettuce, and juicy beef patty.",
      imagePath: "lib/images/burgers/burger4.jpeg",
      price: 4.50,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),

    // chips
    Food(
      name: 'Classic Chips',
      description:
      "Crispy and crunchy chips that serve as a delicious side dish.",
      imagePath: "lib/images/chips/chips.jpg",
      price: 4.50,
      category: FoodCategory.chips,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Chips',
      description:
      "Crispy and crunchy chips that serve as a delicious side dish.",
      imagePath: "lib/images/chips/chips1.jpeg",
      price: 4.50,
      category: FoodCategory.chips,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Chips',
      description:
      "Crispy and crunchy chips that serve as a delicious side dish.",
      imagePath: "lib/images/chips/chips2.jpeg",
      price: 4.50,
      category: FoodCategory.chips,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Chips',
      description:
      "Crispy and crunchy chips that serve as a delicious side dish.",
      imagePath: "lib/images/chips/chips3.jpeg",
      price: 4.50,
      category: FoodCategory.chips,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),
    Food(
      name: 'Chips',
      description:
      "Crispy and crunchy chips that serve as a delicious side dish.",
      imagePath: "lib/images/chips/chips4.jpeg",
      price: 4.50,
      category: FoodCategory.chips,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Extra Pickles", price: 0.99),
        Addon(name: "Extra Bacon", price: 0.99),
      ],
    ),

    // desserts
    Food(
      name: 'Sweet Dessert',
      description: "Sweet and delicious dessert.",
      imagePath: "lib/images/desserts/dessert.jpg",
      price: 4.50,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra Frosting", price: 0.99),
        Addon(name: "Extra Sugar", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Dessert',
      description: "Sweet and delicious dessert.",
      imagePath: "lib/images/desserts/dessert1.jpeg",
      price: 4.50,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra Frosting", price: 0.99),
        Addon(name: "Extra Sugar", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Dessert',
      description: "Sweet and delicious dessert.",
      imagePath: "lib/images/desserts/dessert2.jpeg",
      price: 4.50,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra Frosting", price: 0.99),
        Addon(name: "Extra Sugar", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Dessert',
      description: "Sweet and delicious dessert.",
      imagePath: "lib/images/desserts/dessert3.jpeg",
      price: 4.50,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra Frosting", price: 0.99),
        Addon(name: "Extra Sugar", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Dessert',
      description: "Sweet and delicious dessert.",
      imagePath: "lib/images/desserts/dessert4.jpeg",
      price: 4.50,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Extra Frosting", price: 0.99),
        Addon(name: "Extra Sugar", price: 0.99),
      ],
    ),

    // pastas
    Food(
      name: 'Delicious Pasta',
      description:
      "A staple carbohydrate-rich food made from wheat, often served cooked with sauces, vegetables, or proteins.",
      imagePath: "lib/images/pastas/pasta.jpeg",
      price: 4.50,
      category: FoodCategory.pastas,
      availableAddons: [
        Addon(name: "Extra Sauce", price: 0.99),
        Addon(name: "Extra Cheese", price: 0.99),
      ],
    ),
    Food(
      name: 'Delicious Pasta',
      description:
      "A staple carbohydrate-rich food made from wheat, often served cooked with sauces, vegetables, or proteins.",
      imagePath: "lib/images/pastas/pasta1.jpeg",
      price: 4.50,
      category: FoodCategory.pastas,
      availableAddons: [
        Addon(name: "Extra Sauce", price: 0.99),
        Addon(name: "Extra Cheese", price: 0.99),
      ],
    ),
    Food(
      name: 'Delicious Pasta',
      description:
      "A staple carbohydrate-rich food made from wheat, often served cooked with sauces, vegetables, or proteins.",
      imagePath: "lib/images/pastas/pasta2.jpeg",
      price: 4.50,
      category: FoodCategory.pastas,
      availableAddons: [
        Addon(name: "Extra Sauce", price: 0.99),
        Addon(name: "Extra Cheese", price: 0.99),
      ],
    ),
    Food(
      name: 'Delicious Pasta',
      description:
      "A staple carbohydrate-rich food made from wheat, often served cooked with sauces, vegetables, or proteins.",
      imagePath: "lib/images/pastas/pasta3.jpeg",
      price: 4.50,
      category: FoodCategory.pastas,
      availableAddons: [
        Addon(name: "Extra Sauce", price: 0.99),
        Addon(name: "Extra Cheese", price: 0.99),
      ],
    ),
    Food(
      name: 'Delicious Pasta',
      description:
      "A staple carbohydrate-rich food made from wheat, often served cooked with sauces, vegetables, or proteins.",
      imagePath: "lib/images/pastas/pasta4.jpeg",
      price: 4.50,
      category: FoodCategory.pastas,
      availableAddons: [
        Addon(name: "Extra Sauce", price: 0.99),
        Addon(name: "Extra Cheese", price: 0.99),
      ],
    ),

    // pastries
    Food(
      name: 'Sweet Pastry',
      description: "Baked goods made with dough, often sweet or filled.",
      imagePath: "lib/images/pastries/pastry.jpg",
      price: 4.50,
      category: FoodCategory.pastries,
      availableAddons: [
        Addon(name: "Extra Sugar", price: 0.99),
        Addon(name: "Extra Frosting", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Pastry',
      description: "Baked goods made with dough, often sweet or filled.",
      imagePath: "lib/images/pastries/pastry1.jpeg",
      price: 4.50,
      category: FoodCategory.pastries,
      availableAddons: [
        Addon(name: "Extra Sugar", price: 0.99),
        Addon(name: "Extra Frosting", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Pastry',
      description: "Baked goods made with dough, often sweet or filled.",
      imagePath: "lib/images/pastries/pastry2.jpeg",
      price: 4.50,
      category: FoodCategory.pastries,
      availableAddons: [
        Addon(name: "Extra Sugar", price: 0.99),
        Addon(name: "Extra Frosting", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Pastry',
      description: "Baked goods made with dough, often sweet or filled.",
      imagePath: "lib/images/pastries/pastry3.jpeg",
      price: 4.50,
      category: FoodCategory.pastries,
      availableAddons: [
        Addon(name: "Extra Sugar", price: 0.99),
        Addon(name: "Extra Frosting", price: 0.99),
      ],
    ),
    Food(
      name: 'Sweet Pastry',
      description: "Baked goods made with dough, often sweet or filled.",
      imagePath: "lib/images/pastries/pastry4.jpeg",
      price: 4.50,
      category: FoodCategory.pastries,
      availableAddons: [
        Addon(name: "Extra Sugar", price: 0.99),
        Addon(name: "Extra Frosting", price: 0.99),
      ],
    ),
  ];

  // delivery address
  String _deliveryAddress = 'Kb. Jeruk No. 110 Jakarta Barat';

  /*
  G E T T E R S
  */

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  /*
  O P E R A T I O N S
  */

  //user cart
  final List<CartItem> _cart = [];
  // ListEquality Initialization
  final ListEquality<Addon> _addonEquality = ListEquality();

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
    // see id there is a cart item already with the same food and seelcted addons
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      //check if the food items are the same
      bool isSameFood = item.food == food;

      // check if the list of selected addons are the same
      bool isSameAddons = ListEquality().equals(
        item.selectedAddons,
        selectedAddons,
      );

      return isSameFood && isSameAddons;
    });


    if (cartItem != null) {
      // if item already exists, increase its quantity
      cartItem.quantity++;
    } else {
      // if item not exists, add new
      _cart.add(CartItem(
        food: food,
        selectedAddons: selectedAddons,
        quantity: 1,
      ));
    }
    notifyListeners();
    notifyListeners();
  }

  
  // remove form cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  // get total price of cart
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  // get total number of items in cart
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  // clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // update delivery address
  void updateDeliveryAddress(String newAddress){
    _deliveryAddress = newAddress;
    notifyListeners();
  }
  /*
  H E L P E R S
  */

  // generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    //format the date to include up to seconds only
    String formattedDate =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt
            .writeln("    Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("--------------");
    receipt.writeln("--------------");
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln("Delivering to: $deliveryAddress");

    return receipt.toString();
  }

  // format double value into money
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  // format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
