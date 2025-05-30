
import 'package:flutter/material.dart';
import 'package:foode_waste_app_1/components/my_current_location.dart';
import 'package:foode_waste_app_1/components/my_description_box.dart';
import 'package:foode_waste_app_1/components/my_drawer.dart';
import 'package:foode_waste_app_1/components/my_food_tile.dart';
import 'package:foode_waste_app_1/components/my_sliver_app_bar.dart';
import 'package:foode_waste_app_1/components/my_tab_bar.dart';
import 'package:foode_waste_app_1/models/food.dart';
import 'package:foode_waste_app_1/models/restaurant.dart';
import 'package:foode_waste_app_1/pages/donation_page.dart';
import 'package:foode_waste_app_1/pages/food_page.dart';
import 'package:foode_waste_app_1/pages/cart_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: FoodCategory.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return FoodTile(
            food: food,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodPage(food: food)),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      // Page 0: Menu makanan
      NestedScrollView(
        headerSliverBuilder: (context, _) => [
          MySliverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const MyCurrentLocation(),
                const MyDescriptionBox(),
              ],
            ),
          ),
        ],
        body: Consumer<Restaurant>(
          builder: (context, restaurant, child) =>
              TabBarView(
                controller: _tabController,
                children: getFoodInThisCategory(restaurant.menu),
              ),
        ),
      ),

      // Page 1: Donasi makanan
      const DonationPage(),
    ];

    return Scaffold(
      drawer: MyDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          setState(() => _selectedIndex = newIndex);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donasi',
          ),
        ],
      ),
    );
  }
}

// CODINGAN 1 (BELOM ADA DONATION BARU MAKANAN BIASA)
// import 'package:flutter/material.dart';
// import 'package:foode_waste_app_1/components/my_current_location.dart';
// import 'package:foode_waste_app_1/components/my_description_box.dart'
//     show MyDescriptionBox;
// import 'package:foode_waste_app_1/components/my_drawer.dart';
// import 'package:foode_waste_app_1/components/my_food_tile.dart';
// import 'package:foode_waste_app_1/components/my_sliver_app_bar.dart';
// import 'package:foode_waste_app_1/components/my_tab_bar.dart' show MyTabBar;
// import 'package:foode_waste_app_1/models/food.dart';
// import 'package:foode_waste_app_1/models/restaurant.dart';
// import 'package:foode_waste_app_1/pages/food_page.dart';
// import 'package:provider/provider.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   // tab controller
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       length: FoodCategory.values.length,
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // sort out and return a list of food items that belong to a specific category
//   List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
//     return fullMenu.where((food) => food.category == category).toList();
//   }
//
//   // return list of foods in given category
//   List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
//     return FoodCategory.values.map((category) {
//       // get category menu
//       List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
//       return ListView.builder(
//         itemCount: categoryMenu.length,
//         physics: const NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.zero,
//         itemBuilder: (context, index) {
//           // get individual food
//           final food = categoryMenu[index];
//
//           // return food tile UI
//           return FoodTile(
//             food: food,
//             onTap:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => FoodPage(food: food)),
//                 ),
//           );
//         },
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: MyDrawer(),
//       body: NestedScrollView(
//         headerSliverBuilder:
//             (context, innerBoxIsSCrolled) => [
//               MySliverAppBar(
//                 title: MyTabBar(tabController: _tabController),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Divider(
//                       indent: 25,
//                       endIndent: 25,
//                       color: Theme.of(context).colorScheme.secondary,
//                     ),
//
//                     // my current location
//                     const MyCurrentLocation(),
//
//                     // description box
//                     const MyDescriptionBox(),
//                   ],
//                 ),
//               ),
//             ],
//         body: Consumer<Restaurant>(
//           builder:
//               (context, restaurant, child) => TabBarView(
//                 controller: _tabController,
//                 children: getFoodInThisCategory(restaurant.menu),
//               ),
//         ),
//       ),
//     );
//   }
// }
