import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inventory_item_model.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onDelete;

  const InventoryListItem({
    Key? key,
    required this.item,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = item.expiryDate.difference(now).inDays;
    final Color statusColor;
    final String statusText;

    if (difference < 0) {
      statusColor = Colors.grey;
      statusText = "Expired";
    } else if (difference <= 3) {
      statusColor = Colors.red;
      statusText = "$difference days left";
    } else if (difference <= 7) {
      statusColor = Colors.orange;
      statusText = "$difference days left";
    } else {
      statusColor = Colors.green;
      statusText = "$difference days left";
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Text(
            '${item.quantity}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle:
            Text('Expires on: ${DateFormat.yMMMd().format(item.expiryDate)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            // Show a confirmation dialog before deleting
            showDialog(
              context: context,
              builder: (BuildContext ctx) => AlertDialog(
                title: const Text('Confirm Deletion'),
                content:
                    Text('Are you sure you want to delete "${item.name}"?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onDelete(); // Call the delete callback
                    },
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
