import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SparePart {
  final String id;
  final String name;
  final String category;
  final String compatibleModels;
  final String upiId;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final bool isAvailable;

  const SparePart({
    required this.id,
    required this.name,
    required this.category,
    required this.compatibleModels,
    required this.upiId,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.isAvailable,
  });

  SparePart copyWith({
    String? id,
    String? name,
    String? category,
    String? compatibleModels,
    String? upiId,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return SparePart(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      compatibleModels: compatibleModels ?? this.compatibleModels,
      upiId: upiId ?? this.upiId,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userEmail;
  bool _isLoading = true;
  String? _errorMessage;

  List<SparePart> inventoryParts = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _loadInventoryParts();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (mounted) {
          setState(() {
            _userEmail = user.email;
          });
        }
        print('User email loaded: $_userEmail');
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load user data: $e';
        });
      }
    }
  }

  // Fetch inventory parts for the specific user email only
  Future<void> _loadInventoryParts() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      if (_userEmail == null) {
        await _loadUserData();
        if (_userEmail == null) {
          throw Exception('Unable to get user email');
        }
      }

      print('Loading inventory parts for user: $_userEmail');

      final querySnapshot = await _firestore
          .collection('garage')
          .doc(_userEmail) // Specific user's document
          .collection('spareparts') // Their spare parts collection
          .orderBy('createdAt', descending: true)
          .get();

      print(
        'Found ${querySnapshot.docs.length} inventory parts for $_userEmail',
      );

      if (querySnapshot.docs.isEmpty) {
        print('No inventory parts found for this user');
        if (mounted) {
          setState(() {
            inventoryParts = [];
            _isLoading = false;
          });
        }
        return;
      }

      final List<SparePart> loadedParts = [];

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          print('Processing part: ${data['name']} - ID: ${doc.id}');

          // Validate required fields
          if (data['name'] == null) {
            print('Skipping part with missing name: ${doc.id}');
            continue;
          }

          loadedParts.add(
            SparePart(
              id: doc.id,
              name: data['name']?.toString() ?? 'Unnamed Part',
              category: data['category']?.toString() ?? 'Uncategorized',
              compatibleModels:
                  data['compatibleModels']?.toString() ?? 'Not specified',
              upiId: data['upiId']?.toString() ?? '',
              description: data['description']?.toString() ?? '',
              price: _parsePrice(data['price']),
              stock: _parseStock(data['stock']),
              imageUrl: data['imageUrl']?.toString() ?? '',
              isAvailable: data['isAvailable'] ?? true,
            ),
          );
        } catch (e) {
          print('Error processing document ${doc.id}: $e');
        }
      }

      if (mounted) {
        setState(() {
          inventoryParts = loadedParts;
          _isLoading = false;
        });
      }

      print('Successfully loaded ${loadedParts.length} inventory parts');
    } on FirebaseException catch (e) {
      print('Firestore error loading inventory: ${e.code} - ${e.message}');
      if (mounted) {
        setState(() {
          _errorMessage = 'Database error: ${e.message}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading inventory parts: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load inventory: $e';
          _isLoading = false;
        });
      }
    }
  }

  double _parsePrice(dynamic price) {
    try {
      if (price == null) return 0.0;
      if (price is double) return price;
      if (price is int) return price.toDouble();
      if (price is String) return double.tryParse(price) ?? 0.0;
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  int _parseStock(dynamic stock) {
    try {
      if (stock == null) return 0;
      if (stock is int) return stock;
      if (stock is double) return stock.toInt();
      if (stock is String) return int.tryParse(stock) ?? 0;
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Update stock for specific user's part
  Future<void> _updateStockInFirestore(String partId, int newStock) async {
    try {
      if (_userEmail == null) {
        throw Exception('User email not available');
      }

      await _firestore
          .collection('garage')
          .doc(_userEmail!) // Specific user
          .collection('spareparts')
          .doc(partId) // Specific part
          .update({
            'stock': newStock,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update local state
      if (mounted) {
        setState(() {
          final index = inventoryParts.indexWhere((part) => part.id == partId);
          if (index != -1) {
            inventoryParts[index] = inventoryParts[index].copyWith(
              stock: newStock,
            );
          }
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseException catch (e) {
      print('Firestore error updating stock: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update stock: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Error updating stock: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update stock: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Toggle availability for specific user's part
  Future<void> _toggleAvailabilityInFirestore(
    String partId,
    bool currentStatus,
  ) async {
    try {
      if (_userEmail == null) {
        throw Exception('User email not available');
      }

      final bool newStatus = !currentStatus;

      await _firestore
          .collection('garage')
          .doc(_userEmail!) // Specific user
          .collection('spareparts')
          .doc(partId) // Specific part
          .update({
            'isAvailable': newStatus,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update local state
      if (mounted) {
        setState(() {
          final index = inventoryParts.indexWhere((part) => part.id == partId);
          if (index != -1) {
            inventoryParts[index] = inventoryParts[index].copyWith(
              isAvailable: newStatus,
            );
          }
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Part ${newStatus ? 'enabled' : 'disabled'} successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseException catch (e) {
      print('Firestore error toggling availability: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update availability: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Error toggling availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update availability: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add new part to user's inventory
  Future<void> _addNewPart() async {
    try {
      if (_userEmail == null) {
        throw Exception('User email not available');
      }

      // Example of adding a new part - you can customize this
      final newPartData = {
        'name': 'New Spare Part',
        'category': '4-Wheeler',
        'compatibleModels': 'All Models',
        'upiId': '',
        'description': 'New spare part description',
        'price': 0.0,
        'stock': 0,
        'imageUrl': '',
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('garage')
          .doc(_userEmail!)
          .collection('spareparts')
          .add(newPartData);

      // Reload inventory to show the new part
      await _loadInventoryParts();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New part added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error adding new part: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add new part: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInventoryParts,
            tooltip: 'Refresh Inventory',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewPart,
            tooltip: 'Add New Part',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
          ? _buildErrorState()
          : Column(
              children: [
                _buildInventoryHeader(),
                Expanded(
                  child: inventoryParts.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadInventoryParts,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: inventoryParts.length,
                            itemBuilder: (context, index) {
                              return _buildInventoryItem(inventoryParts[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF2563EB)),
          const SizedBox(height: 16),
          Text(
            'Loading inventory...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          if (_userEmail != null) ...[
            const SizedBox(height: 8),
            Text(
              'for $_userEmail',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadInventoryParts,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Retry'),
          ),
          const SizedBox(height: 10),
          if (_userEmail != null)
            Text(
              'User: $_userEmail',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Inventory Items',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first spare part to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addNewPart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Add First Part'),
          ),
          if (_userEmail != null) ...[
            const SizedBox(height: 10),
            Text(
              'User: $_userEmail',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInventoryHeader() {
    final lowStockCount = inventoryParts
        .where((part) => part.stock < 5 && part.stock > 0)
        .length;
    final outOfStockCount = inventoryParts
        .where((part) => part.stock == 0)
        .length;
    final disabledCount = inventoryParts
        .where((part) => !part.isAvailable)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Inventory Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              if (_userEmail != null)
                Text(
                  'User: ${_userEmail!.split('@')[0]}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInventoryStat(
                'Low Stock',
                lowStockCount.toString(),
                const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              _buildInventoryStat(
                'Out of Stock',
                outOfStockCount.toString(),
                const Color(0xFFEF4444),
              ),
              const SizedBox(width: 8),
              _buildInventoryStat(
                'Disabled',
                disabledCount.toString(),
                const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              _buildInventoryStat(
                'Total Items',
                inventoryParts.length.toString(),
                const Color(0xFF2563EB),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStat(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(SparePart part) {
    final Color statusColor = _getStockStatusColor(
      part.stock,
      part.isAvailable,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.inventory_2, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        part.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    if (!part.isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DISABLED',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  part.category,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  part.compatibleModels,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Stock: ${part.stock}',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${part.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'edit_stock',
                child: Text('Edit Stock'),
              ),
              PopupMenuItem<String>(
                value: 'toggle_availability',
                child: Text(part.isAvailable ? 'Disable Part' : 'Enable Part'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit_stock') {
                _editStock(part);
              } else if (value == 'toggle_availability') {
                _toggleAvailability(part);
              }
            },
          ),
        ],
      ),
    );
  }

  Color _getStockStatusColor(int stock, bool isAvailable) {
    if (!isAvailable) return const Color(0xFFEF4444);
    if (stock == 0) return const Color(0xFFEF4444);
    if (stock < 5) return const Color(0xFFF59E0B);
    return const Color(0xFF2563EB);
  }

  void _editStock(SparePart part) {
    final TextEditingController stockController = TextEditingController(
      text: part.stock.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock for ${part.name}'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Stock Quantity',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final int newStock =
                  int.tryParse(stockController.text) ?? part.stock;
              _updateStockInFirestore(part.id, newStock);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _toggleAvailability(SparePart part) {
    _toggleAvailabilityInFirestore(part.id, part.isAvailable);
  }
}
