import 'package:flutter/material.dart';

enum DrawerType { profile, cart, notify }

class CustomDrawer extends StatelessWidget {
  final DrawerType type;
  const CustomDrawer({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case DrawerType.profile:
        content = _buildProfileDrawer(context);
        break;
      case DrawerType.cart:
        content = _buildCartDrawer(context);
        break;
      case DrawerType.notify:
        content = _buildNotifyDrawer(context);
        break;
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: const Color(0xFFE95322),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(child: content),
    );
  }

  /// Drawer hồ sơ người dùng
  Widget _buildProfileDrawer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
          const SizedBox(height: 12),
          const Text(
            'John Smith',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Loremipsum@email.com',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 30),
          _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders'),
          _buildMenuItem(Icons.person_outline, 'My Profile'),
          _buildMenuItem(Icons.location_on_outlined, 'Delivery Address'),
          _buildMenuItem(Icons.credit_card_outlined, 'Payment Methods'),
          _buildMenuItem(Icons.call_outlined, 'Contact Us'),
          _buildMenuItem(Icons.settings_outlined, 'Settings'),
          const Spacer(),
          const Divider(color: Colors.white54),
          _buildMenuItem(Icons.logout, 'Log Out'),
        ],
      ),
    );
  }

  /// Drawer giỏ hàng
  Widget _buildCartDrawer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Pizza Margherita',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      '\$12.99',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Drawer thông báo
  Widget _buildNotifyDrawer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    'Your order #1234 is on the way!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    '50% off on desserts today!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
