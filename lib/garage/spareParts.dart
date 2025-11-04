import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SparePartsScreen extends StatefulWidget {
  const SparePartsScreen({super.key});

  @override
  _SparePartsScreenState createState() => _SparePartsScreenState();
}

class _SparePartsScreenState extends State<SparePartsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<SparePart> spareParts = [];
  String selectedCategory = 'All';
  String searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpareParts();
  }

  Future<void> _loadSpareParts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('garage')
          .doc(user.email)
          .collection('spareparts')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        spareParts = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return SparePart(
            id: doc.id,
            name: data['name'] ?? '',
            category: data['category'] ?? '',
            compatibleModels: data['compatibleModels'] ?? '',
            description: data['description'] ?? '',
            price: (data['price'] ?? 0).toDouble(),
            stock: data['stock'] ?? 0,
            imageUrl: data['imageUrl'] ?? '',
            upiId: data['upiId'] ?? '', // Added UPI ID field
            isAvailable: data['isAvailable'] ?? true,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading spare parts: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading spare parts: $e')),
      );
    }
  }

  List<SparePart> get filteredParts {
    List<SparePart> filtered = spareParts;

    if (selectedCategory != 'All') {
      filtered = filtered.where((part) => part.category == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((part) =>
          part.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          part.description.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchFilter(),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : filteredParts.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredParts.length,
                        itemBuilder: (context, index) {
                          return _buildSparePartCard(filteredParts[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF2563EB),
        onPressed: _showAddPartDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2563EB)),
          SizedBox(height: 16),
          Text(
            'Loading spare parts...',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search spare parts...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF1F5F9),
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', '2-Wheeler', '4-Wheeler', 'Truck', 'Low Stock']
                  .map((category) => _buildFilterChip(category))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2563EB) : Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSparePartCard(SparePart part) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: part.isAvailable ? Color(0xFF2563EB).withOpacity(0.1) : Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Icon(
              Icons.inventory_2,
              color: part.isAvailable ? Color(0xFF2563EB) : Color(0xFFEF4444),
              size: 40,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          part.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(part.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          part.category,
                          style: TextStyle(
                            color: _getCategoryColor(part.category),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    part.description,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (part.upiId.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.payment, size: 12, color: Color(0xFF64748B)),
                        SizedBox(width: 4),
                        Text(
                          'UPI: ${part.upiId}',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                  ],
                  Row(
                    children: [
                      Text(
                        '₹${part.price}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.inventory, size: 14, color: Color(0xFF64748B)),
                      SizedBox(width: 4),
                      Text(
                        'Stock: ${part.stock}',
                        style: TextStyle(
                          color: part.stock < 5 ? Color(0xFFEF4444) : Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: part.stock < 5 ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _editPart(part),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2563EB),
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text('Edit'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _deletePart(part),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFEF4444),
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 64, color: Color(0xFFCBD5E1)),
          SizedBox(height: 16),
          Text(
            'No parts found',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try changing your filters or add a new part',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '2-Wheeler':
        return Color(0xFF3B82F6);
      case '4-Wheeler':
        return Color(0xFF2563EB);
      case 'Truck':
        return Color(0xFFF59E0B);
      default:
        return Color(0xFF8B5CF6);
    }
  }

  void _showAddPartDialog() {
    showDialog(
      context: context,
      builder: (context) => AddPartDialog(
        onPartAdded: _addPartToFirestore,
      ),
    );
  }

  Future<void> _addPartToFirestore(SparePart part) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final partData = {
        'name': part.name,
        'category': part.category,
        'compatibleModels': part.compatibleModels,
        'description': part.description,
        'price': part.price,
        'email': user.email,
        'stock': part.stock,
        'imageUrl': part.imageUrl,
        'upiId': part.upiId, // Added UPI ID to Firebase
        'isAvailable': part.isAvailable,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('garage')
          .doc(user.email)
          .collection('spareparts')
          .doc(part.id)
          .set(partData);

      // Reload the parts list
      await _loadSpareParts();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Part added successfully')),
      );
    } catch (e) {
      print('Error adding part: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding part: $e')),
      );
    }
  }

  void _editPart(SparePart part) {
    showDialog(
      context: context,
      builder: (context) => AddPartDialog(
        part: part,
        onPartAdded: _updatePartInFirestore,
      ),
    );
  }

  Future<void> _updatePartInFirestore(SparePart part) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final partData = {
        'name': part.name,
        'category': part.category,
        'compatibleModels': part.compatibleModels,
        'description': part.description,
        'price': part.price,
        'stock': part.stock,
        'imageUrl': part.imageUrl,
        'upiId': part.upiId, // Added UPI ID to update operation
        'isAvailable': part.isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('garage')
          .doc(user.email)
          .collection('spareparts')
          .doc(part.id)
          .update(partData);

      // Reload the parts list
      await _loadSpareParts();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Part updated successfully')),
      );
    } catch (e) {
      print('Error updating part: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating part: $e')),
      );
    }
  }

  void _deletePart(SparePart part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Part'),
        content: Text('Are you sure you want to delete ${part.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _deletePartFromFirestore(part),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePartFromFirestore(SparePart part) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      await _firestore
          .collection('garage')
          .doc(user.email)
          .collection('spareparts')
          .doc(part.id)
          .delete();

      // Reload the parts list
      await _loadSpareParts();
      
      Navigator.pop(context); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${part.name} deleted successfully')),
      );
    } catch (e) {
      print('Error deleting part: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting part: $e')),
      );
    }
  }
}

class AddPartDialog extends StatefulWidget {

  const AddPartDialog({super.key, this.part, required this.onPartAdded});
  final SparePart? part;
  final Function(SparePart) onPartAdded;

  @override
  _AddPartDialogState createState() => _AddPartDialogState();
}

class _AddPartDialogState extends State<AddPartDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController(); // Added UPI ID controller

  String _selectedCategory = '4-Wheeler';
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    if (widget.part != null) {
      _nameController.text = widget.part!.name;
      _selectedCategory = widget.part!.category;
      _modelsController.text = widget.part!.compatibleModels;
      _descriptionController.text = widget.part!.description;
      _priceController.text = widget.part!.price.toString();
      _stockController.text = widget.part!.stock.toString();
      _upiIdController.text = widget.part!.upiId; // Initialize UPI ID
      _isAvailable = widget.part!.isAvailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.part == null ? 'Add New Spare Part' : 'Edit Spare Part'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Part Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter part name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                initialValue: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: ['2-Wheeler', '4-Wheeler', 'Truck', 'Universal']
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _modelsController,
                decoration: InputDecoration(labelText: 'Compatible Models'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter compatible models';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price (₹)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter valid quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _upiIdController,
                decoration: InputDecoration(
                  labelText: 'UPI ID',
                  hintText: 'e.g., yourname@upi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter UPI ID';
                  }
                  // Basic UPI ID validation
                  if (!value.contains('@')) {
                    return 'Please enter a valid UPI ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Available:'),
                  SizedBox(width: 8),
                  Switch(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    activeThumbColor: Color(0xFF2563EB),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _savePart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2563EB),
          ),
          child: Text(widget.part == null ? 'Add Part' : 'Update Part'),
        ),
      ],
    );
  }

  void _savePart() {
    if (_formKey.currentState!.validate()) {
      SparePart part = SparePart(
        id: widget.part?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _selectedCategory,
        compatibleModels: _modelsController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        imageUrl: '',
        upiId: _upiIdController.text, // Added UPI ID
        isAvailable: _isAvailable,
      );

      widget.onPartAdded(part);
      Navigator.pop(context);
    }
  }
}

// Data Model for Spare Parts
class SparePart {

  SparePart({
    required this.id,
    required this.name,
    required this.category,
    required this.compatibleModels,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.upiId, // Added UPI ID parameter
    required this.isAvailable,
  });
  final String id;
  final String name;
  final String category;
  final String compatibleModels;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final String upiId; // Added UPI ID field
  final bool isAvailable;

  SparePart copyWith({
    String? id,
    String? name,
    String? category,
    String? compatibleModels,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    String? upiId, // Added UPI ID to copyWith
    bool? isAvailable,
  }) {
    return SparePart(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      compatibleModels: compatibleModels ?? this.compatibleModels,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      upiId: upiId ?? this.upiId, // Added UPI ID
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}