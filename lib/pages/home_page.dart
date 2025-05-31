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
import 'package:foode_waste_app_1/pages/transaction_history_page.dart';  // <- import halaman history pembelian
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: FoodCategory.values.length,
      vsync: this,
    );
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        userRole = null;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists && doc.data() != null && doc.data()!.containsKey('role')) {
      setState(() {
        userRole = doc.data()!['role'] as String?;
      });
    } else {
      setState(() {
        userRole = null;
      });
    }
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
    if (userRole == null) {
      // Loading spinner saat role belum ter-load
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          builder: (context, restaurant, child) => TabBarView(
            controller: _tabController,
            children: getFoodInThisCategory(restaurant.menu),
          ),
        ),
      ),

      // Page 1: Donasi jika Penjual, History Pembelian jika Pembeli, else info
      if (userRole == 'Penjual')
        const DonationPage(isSeller: true)
      else if (userRole == 'Pembeli')
        const TransactionHistoryPage()
      else
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Halaman ini hanya dapat diakses oleh Penjual atau Pembeli.',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ];

    return Scaffold(
      drawer: const MyDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          setState(() => _selectedIndex = newIndex);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: userRole == 'Penjual'
                ? 'Donasi'
                : (userRole == 'Pembeli' ? 'History' : 'Tidak tersedia'),
          ),
        ],
      ),
    );
  }
}
