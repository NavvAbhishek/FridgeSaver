import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_input_field.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _quantity = 1;
  DateTime? _expiryDate;
  bool _isLoading = false;

  Future<void> _pickExpiryDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 365 * 5)), // 5 years from now
    );
    if (pickedDate != null) {
      setState(() {
        _expiryDate = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_expiryDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select an expiry date'),
              backgroundColor: Colors.red),
        );
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        // Format date to "YYYY-MM-DD"
        final formattedDate = DateFormat('yyyy-MM-dd').format(_expiryDate!);
        await ApiService.addItem(
            name: _name, quantity: _quantity, expiryDate: formattedDate);

        if (mounted) {
          Navigator.pop(
              context, true); // Pop screen and return true to signal success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to add item: $e'),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text("Item Name",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                RoundedInputField(
                  hintText: "e.g., Milk, 1L",
                  icon: Icons.fastfood,
                  onSaved: (value) => _name = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an item name' : null,
                ),
                const SizedBox(height: 24),
                Text("Quantity",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                RoundedInputField(
                  hintText: "e.g., 1",
                  icon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _quantity = int.tryParse(value!) ?? 1,
                  initialValue: '1',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a quantity';
                    if (int.tryParse(value) == null || int.parse(value) < 1)
                      return 'Please enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text("Expiry Date",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickExpiryDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 15),
                        Text(
                          _expiryDate == null
                              ? 'Select a date'
                              : DateFormat.yMMMMd()
                                  .format(_expiryDate!), // e.g., July 29, 2025
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RoundedButton(text: "ADD ITEM", onPressed: _submitForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
