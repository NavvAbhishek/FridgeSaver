import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventory_item_model.dart';
import '../services/api_service.dart';
import '../widgets/inventory_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<InventoryItem>> _inventoryFuture;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() {
    setState(() {
      _inventoryFuture = ApiService.getInventoryItems();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data on logout
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  void _deleteItem(int id) async {
    try {
      await ApiService.deleteItem(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Item deleted successfully'),
            backgroundColor: Colors.green),
      );
      _loadInventory(); // Refresh the list after deleting
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete item: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Fridge"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<List<InventoryItem>>(
        future: _inventoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Your fridge is empty.\nTap the '+' button to add an item!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Data has been successfully loaded
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return InventoryListItem(
                item: items[index],
                onDelete: () => _deleteItem(items[index].id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddItemScreen and wait for a result
          final result = await Navigator.pushNamed(context, '/add_item');
          // If an item was added, refresh the list
          if (result == true) {
            _loadInventory();
          }
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
