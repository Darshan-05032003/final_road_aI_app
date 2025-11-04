// import 'package:ai/controller/sharedprefrence.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SparePartsStore extends StatefulWidget {
//   const SparePartsStore({super.key});

//   @override
//   _SparePartsStoreState createState() => _SparePartsStoreState();
// }

// class _SparePartsStoreState extends State<SparePartsStore> {
//   int _selectedCategory = 0;
//   String _searchQuery = '';
//   List<Map<String, dynamic>> _cartItems = [];
//   double _cartTotal = 0.0;
//   bool _isLoading = true;
//   String? _userEmail;
//   String? _sparePartEmail;

//   final List<String> _categories = ['All', '2-Wheeler', '4-Wheeler', 'Truck', 'Accessories'];
//   final List<String> _categoryIcons = ['🏠', '🏍️', '🚗', '🚛', '🔧'];

//   List<Map<String, dynamic>> _spareParts = [];
//   final List<Map<String, dynamic>> _featuredParts = [];

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     await _loadUserData();
//     await _loadSpareParts();
//     _loadFeaturedFromSpareParts();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       String? userEmail = await AuthService.getUserEmail();
//       setState(() {
//         _userEmail = userEmail;
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//       setState(() {
//         _userEmail = _auth.currentUser?.email;
//       });
//     }
//   }

//   // Fixed _loadSpareParts method to fetch all emails from spareparts
//   Future<void> _loadSpareParts() async {
//     try {
//       // First try to get user email from SharedPreferences
//       if (_userEmail == null) {
//         await _loadUserData();
//       }

//       // If still no user email, use Firebase Auth current user
//       final String? userEmail = _userEmail ?? _auth.currentUser?.email;

//       if (userEmail == null) {
//         print('No user email found');
//         _loadLocalData();
//         return;
//       }

//       print('Loading spare parts for user: $userEmail');

//       final querySnapshot = await _firestore
//           .collection('garage')
//           .doc(userEmail)
//           .collection('spareparts')
//           .orderBy('createdAt', descending: true)
//           .get();

//       print('Found ${querySnapshot.docs.length} spare parts');

//       setState(() {
//         _spareParts = querySnapshot.docs.map((doc) {
//           final data = doc.data();
//           print('Processing part: ${data['name']}');

//           // Store the email from spareparts collection
//           final partEmail = data['email'] ?? userEmail;
//           _sparePartEmail = partEmail; // Store for use in checkout
//           print('Part email: $partEmail');

//           return {
//             'id': doc.id,
//             'name': data['name'] ?? '',
//             'description': data['description'] ?? '',
//             'price': (data['price'] ?? 0).toDouble(),
//             'originalPrice': (data['originalPrice'] ?? (data['price'] ?? 0) * 1.2).toDouble(),
//             'category': data['category'] ?? 'Accessories',
//             'brand': data['brand'] ?? 'Generic',
//             'rating': (data['rating'] ?? 4.0).toDouble(),
//             'reviews': data['reviews'] ?? 0,
//             'stock': data['stock'] ?? 0,
//             'image': _getPartIcon(data['category'] ?? ''),
//             'compatibility': _parseCompatibility(data['compatibleModels']),
//             'warranty': data['warranty'] ?? '1 Year',
//             'deliveryTime': data['deliveryTime'] ?? '2-3 days',
//             'seller': _getSellerFromEmail(partEmail),
//             'sellerRating': (data['sellerRating'] ?? 4.5).toDouble(),
//             'isAvailable': data['isAvailable'] ?? true,
//             'email': partEmail, // Store email with each part
//           };
//         }).toList();
//         _isLoading = false;
//       });

//       print('Successfully loaded ${_spareParts.length} spare parts');

//     } catch (e) {
//       print('Error loading spare parts: $e');
//       setState(() {
//         _isLoading = false;
//       });
//       // Fallback to local data if Firebase fails
//       _loadLocalData();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading spare parts: $e')),
//       );
//     }
//   }

//   // Helper method to get seller name from email
//   String _getSellerFromEmail(String email) {
//     try {
//       return email.split('@').first;
//     } catch (e) {
//       print('Error parsing seller from email: $e');
//     }
//     return 'Auto Parts Store';
//   }

//   // Helper method to get appropriate icon for category
//   String _getPartIcon(String category) {
//     switch (category.toLowerCase()) {
//       case '2-wheeler':
//         return '🏍️';
//       case '4-wheeler':
//         return '🚗';
//       case 'truck':
//         return '🚛';
//       case 'universal':
//         return '🛠️';
//       default:
//         return '🔧';
//     }
//   }

//   void _loadFeaturedFromSpareParts() {
//     if (_spareParts.length >= 2) {
//       setState(() {
//         _featuredParts.clear();
//         _featuredParts.addAll([
//           {
//             ..._spareParts[0],
//             'tag': 'Popular',
//             'image': '🎯',
//           },
//           {
//             ..._spareParts[1],
//             'tag': 'Best Value',
//             'image': '🛠️',
//           },
//         ]);
//       });
//     } else if (_spareParts.isNotEmpty) {
//       setState(() {
//         _featuredParts.clear();
//         _featuredParts.addAll(_spareParts.map((part) => {
//           ...part,
//           'tag': 'Featured',
//           'image': '🎯',
//         }).toList());
//       });
//     } else {
//       _loadLocalFeaturedData();
//     }
//   }

//   // Fallback local data
//   void _loadLocalData() {
//     print('Loading local fallback data');
//     _spareParts = [
//       {
//         'id': '1',
//         'name': 'Engine Oil - Synthetic',
//         'description': 'Premium synthetic engine oil for better performance and longer engine life',
//         'price': 45.99,
//         'originalPrice': 55.99,
//         'category': '4-Wheeler',
//         'brand': 'Shell',
//         'rating': 4.5,
//         'reviews': 128,
//         'stock': 25,
//         'image': '🛢️',
//         'compatibility': ['Sedan', 'SUV', 'Hatchback'],
//         'warranty': '1 Year',
//         'deliveryTime': '2-3 days',
//         'seller': 'AutoParts Pro',
//         'sellerRating': 4.8,
//         'isAvailable': true,
//         'email': 'autoparts@example.com',
//       },
//       {
//         'id': '2',
//         'name': 'Bike Chain Set',
//         'description': 'High-quality chain set for motorcycles with excellent durability',
//         'price': 29.99,
//         'originalPrice': 39.99,
//         'category': '2-Wheeler',
//         'brand': 'RK',
//         'rating': 4.3,
//         'reviews': 89,
//         'stock': 15,
//         'image': '⛓️',
//         'compatibility': ['Sports Bike', 'Cruiser'],
//         'warranty': '6 Months',
//         'deliveryTime': '1-2 days',
//         'seller': 'Bike Masters',
//         'sellerRating': 4.6,
//         'isAvailable': true,
//         'email': 'bikemasters@example.com',
//       },
//     ];
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _loadLocalFeaturedData() {
//     _featuredParts.addAll([
//       {
//         'id': 'f1',
//         'name': 'Limited Offer - Brake Kit',
//         'description': 'Complete brake kit with 40% discount',
//         'price': 129.99,
//         'originalPrice': 199.99,
//         'category': '4-Wheeler',
//         'image': '🎯',
//         'tag': 'Limited Offer',
//         'email': 'specialoffers@example.com',
//       },
//       {
//         'id': 'f2',
//         'name': 'Bike Service Kit',
//         'description': 'Complete maintenance kit for motorcycles',
//         'price': 39.99,
//         'originalPrice': 59.99,
//         'category': '2-Wheeler',
//         'image': '🛠️',
//         'tag': 'Best Seller',
//         'email': 'bikemasters@example.com',
//       },
//     ]);
//   }

//   List<String> _parseCompatibility(dynamic compatibility) {
//     if (compatibility is List) {
//       return compatibility.cast<String>();
//     } else if (compatibility is String) {
//       return compatibility.split(',').map((e) => e.trim()).toList();
//     }
//     return ['Universal Fit'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: _buildAppBar(),
//       body: _isLoading
//           ? _buildLoadingState()
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildSearchBar(),
//                   if (_featuredParts.isNotEmpty) _buildFeaturedSection(),
//                   _buildCategoryTabs(),
//                   _buildPartsGrid(),
//                 ],
//               ),
//             ),
//       floatingActionButton: _cartItems.isNotEmpty ? _buildCartFAB() : null,
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF6D28D9)),
//           SizedBox(height: 16),
//           Text(
//             'Loading spare parts...',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '🛠️ Spare Parts Store',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             'Genuine Parts • Fast Delivery',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Color(0xFF6D28D9),
//       foregroundColor: Colors.white,
//       elevation: 0,
//       actions: [
//         IconButton(
//           icon: Stack(
//             children: [
//               Icon(Icons.shopping_cart_rounded),
//               if (_cartItems.isNotEmpty)
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     constraints: BoxConstraints(
//                       minWidth: 16,
//                       minHeight: 16,
//                     ),
//                     child: Text(
//                       _cartItems.length.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           onPressed: _showCart,
//         ),
//         IconButton(
//           icon: Icon(Icons.history_rounded),
//           onPressed: _showOrderHistory,
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: TextField(
//         onChanged: (value) {
//           setState(() {
//             _searchQuery = value;
//           });
//         },
//         decoration: InputDecoration(
//           hintText: 'Search spare parts...',
//           prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6D28D9)),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeaturedSection() {
//     return SizedBox(
//       height: 160,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         itemCount: _featuredParts.length,
//         itemBuilder: (context, index) {
//           final part = _featuredParts[index];
//           return Container(
//             width: 280,
//             margin: EdgeInsets.only(right: 12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
//               ),
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0xFF6D28D9).withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   right: -20,
//                   top: -20,
//                   child: Text(
//                     part['image'],
//                     style: TextStyle(fontSize: 80, color: Colors.white.withOpacity(0.1)),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           part['tag'],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         part['name'],
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         part['description'],
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             '₹${part['price']}',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             '₹${part['originalPrice']}',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCategoryTabs() {
//     return SafeArea(
//       child: SizedBox(
//         height: 120,
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double availableWidth = constraints.maxWidth;

//             return ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(
//                 horizontal: availableWidth < 400 ? 16 : 36,
//                 vertical: 16,
//               ),
//               itemCount: _categories.length,
//               itemBuilder: (context, index) {
//                 final double itemWidth = _calculateItemWidth(availableWidth);

//                 return Container(
//                   width: itemWidth,
//                   margin: EdgeInsets.only(
//                     right: availableWidth < 400 ? 8 : 12,
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedCategory = index;
//                       });
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: availableWidth < 400 ? 12 : 20,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _selectedCategory == index ? Color(0xFF6D28D9) : Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             _categoryIcons[index],
//                             style: TextStyle(
//                               fontSize: availableWidth < 400 ? 16 : 20,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             _categories[index],
//                             style: TextStyle(
//                               fontSize: availableWidth < 400 ? 10 : 12,
//                               fontWeight: FontWeight.w600,
//                               color: _selectedCategory == index ? Colors.white : Colors.grey[700],
//                             ),
//                             textAlign: TextAlign.center,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   double _calculateItemWidth(double availableWidth) {
//     if (availableWidth < 320) return 70;
//     if (availableWidth < 400) return 80;
//     if (availableWidth < 500) return 90;
//     return 100;
//   }

//   Widget _buildPartsGrid() {
//     List<Map<String, dynamic>> filteredParts = _spareParts.where((part) {
//       final matchesCategory = _selectedCategory == 0 || part['category'] == _categories[_selectedCategory];
//       final matchesSearch = _searchQuery.isEmpty ||
//           part['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           part['description'].toLowerCase().contains(_searchQuery.toLowerCase());
//       return matchesCategory && matchesSearch;
//     }).toList();

//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: filteredParts.isEmpty
//           ? _buildEmptyState()
//           : GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: filteredParts.length,
//               itemBuilder: (context, index) {
//                 final part = filteredParts[index];
//                 return _buildPartCard(part);
//               },
//             ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return SizedBox(
//       height: 200,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
//             SizedBox(height: 16),
//             Text(
//               'No parts found',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Try changing your search or filters',
//               style: TextStyle(
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPartCard(Map<String, dynamic> part) {
//     bool isInCart = _cartItems.any((item) => item['id'] == part['id']);

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _showPartDetails(part),
//         child: Container(
//           padding: EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Part Image/Icon
//               Center(
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF6D28D9).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(
//                     child: Text(
//                       part['image'],
//                       style: TextStyle(fontSize: 30),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8),

//               // Part Name
//               Text(
//                 part['name'],
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               SizedBox(height: 4),

//               // Brand and Rating
//               Row(
//                 children: [
//                   Text(
//                     part['brand'],
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Spacer(),
//                   Icon(Icons.star_rounded, color: Colors.amber, size: 14),
//                   Text(
//                     '${part['rating']}',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 4),

//               // Price
//               Row(
//                 children: [
//                   Text(
//                     '₹${part['price']}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF6D28D9),
//                     ),
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     '₹${part['originalPrice']}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                       decoration: TextDecoration.lineThrough,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),

//               // Add to Cart Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isInCart ? null : () => _addToCart(part),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isInCart ? Colors.grey : Color(0xFF6D28D9),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 8),
//                   ),
//                   child: Text(
//                     isInCart ? 'Added to Cart' : 'Add to Cart',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCartFAB() {
//     return FloatingActionButton.extended(
//       onPressed: _showCart,
//       backgroundColor: Color(0xFF6D28D9),
//       foregroundColor: Colors.white,
//       icon: Icon(Icons.shopping_cart_rounded),
//       label: Text(
//         '₹${_cartTotal.toStringAsFixed(2)}',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   void _addToCart(Map<String, dynamic> part) {
//     setState(() {
//       _cartItems.add({
//         ...part,
//         'quantity': 1,
//         'addedAt': DateTime.now(),
//       });
//       _updateCartTotal();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('${part['name']} added to cart!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   void _updateCartTotal() {
//     _cartTotal = _cartItems.fold(0.0, (total, item) => total + (item['price'] * item['quantity']));
//   }

//   void _showPartDetails(Map<String, dynamic> part) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => PartDetailsBottomSheet(
//         part: part,
//         onAddToCart: () => _addToCart(part),
//       ),
//     );
//   }

//   void _showCart() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => CartBottomSheet(
//         cartItems: _cartItems,
//         onUpdateCart: _updateCart,
//         onCheckout: _proceedToCheckout,
//       ),
//     );
//   }

//   void _updateCart(List<Map<String, dynamic>> updatedCart) {
//     setState(() {
//       _cartItems = updatedCart;
//       _updateCartTotal();
//     });
//   }

//   void _proceedToCheckout() {
//     Navigator.pop(context); // Close cart
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CheckoutScreen(
//           cartItems: _cartItems,
//           totalAmount: _cartTotal,
//           onOrderPlaced: _clearCart,
//           sparePartEmail: _getSparePartEmailFromCart(),
//         ),
//       ),
//     );
//   }

//   // Get email from spareparts collection for checkout
//   String? _getSparePartEmailFromCart() {
//     if (_cartItems.isNotEmpty) {
//       return _cartItems.first['email'] ?? _sparePartEmail ?? _userEmail;
//     }
//     return _sparePartEmail ?? _userEmail;
//   }

//   void _clearCart() {
//     setState(() {
//       _cartItems.clear();
//       _cartTotal = 0.0;
//     });
//   }

//   void _showOrderHistory() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Order History - Coming Soon!'),
//         backgroundColor: Color(0xFF6D28D9),
//       ),
//     );
//   }
// }

// // Part Details Bottom Sheet
// class PartDetailsBottomSheet extends StatelessWidget {
//   final Map<String, dynamic> part;
//   final VoidCallback onAddToCart;

//   const PartDetailsBottomSheet({
//     super.key,
//     required this.part,
//     required this.onAddToCart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 60,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),

//           // Part Header
//           Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF6D28D9).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     part['image'],
//                     style: TextStyle(fontSize: 30),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       part['name'],
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       part['brand'],
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),

//           // Price Section
//           Row(
//             children: [
//               Text(
//                 '₹${part['price']}',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF6D28D9),
//                 ),
//               ),
//               SizedBox(width: 8),
//               Text(
//                 '₹${part['originalPrice']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                   decoration: TextDecoration.lineThrough,
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   '${((part['originalPrice'] - part['price']) / part['originalPrice'] * 100).toStringAsFixed(0)}% OFF',
//                   style: TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),

//           // Rating and Reviews
//           Row(
//             children: [
//               Icon(Icons.star_rounded, color: Colors.amber, size: 20),
//               SizedBox(width: 4),
//               Text(
//                 '${part['rating']}',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(width: 4),
//               Text(
//                 '(${part['reviews']} reviews)',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               Spacer(),
//               Icon(Icons.inventory_2_rounded, color: Colors.blue, size: 20),
//               SizedBox(width: 4),
//               Text(
//                 '${part['stock']} in stock',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),

//           // Description
//           Text(
//             'Description',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             part['description'],
//             style: TextStyle(
//               color: Colors.grey[700],
//               height: 1.5,
//             ),
//           ),
//           SizedBox(height: 16),

//           // Specifications
//           _buildSpecItem('Category', part['category']),
//           _buildSpecItem('Compatibility', part['compatibility'].join(', ')),
//           _buildSpecItem('Warranty', part['warranty']),
//           _buildSpecItem('Delivery', part['deliveryTime']),
//           _buildSpecItem('Seller', '${part['seller']} ⭐ ${part['sellerRating']}'),
//           _buildSpecItem('Seller Email', part['email'] ?? 'Not specified'),

//           SizedBox(height: 20),

//           // Action Buttons
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Color(0xFF6D28D9),
//                     side: BorderSide(color: Color(0xFF6D28D9)),
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: Text('Close'),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     onAddToCart();
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF6D28D9),
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: Text('Add to Cart'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSpecItem(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Text(
//             '$label:',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

// // Cart Bottom Sheet
// class CartBottomSheet extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final Function(List<Map<String, dynamic>>) onUpdateCart;
//   final VoidCallback onCheckout;

//   const CartBottomSheet({
//     super.key,
//     required this.cartItems,
//     required this.onUpdateCart,
//     required this.onCheckout,
//   });

//   @override
//   _CartBottomSheetState createState() => _CartBottomSheetState();
// }

// class _CartBottomSheetState extends State<CartBottomSheet> {
//   late List<Map<String, dynamic>> _cartItems;

//   @override
//   void initState() {
//     super.initState();
//     _cartItems = List.from(widget.cartItems);
//   }

//   void _updateQuantity(int index, int newQuantity) {
//     if (newQuantity <= 0) {
//       _removeItem(index);
//     } else {
//       setState(() {
//         _cartItems[index]['quantity'] = newQuantity;
//       });
//       widget.onUpdateCart(_cartItems);
//     }
//   }

//   void _removeItem(int index) {
//     setState(() {
//       _cartItems.removeAt(index);
//     });
//     widget.onUpdateCart(_cartItems);
//   }

//   double get _totalAmount {
//     return _cartItems.fold(0.0, (total, item) => total + (item['price'] * item['quantity']));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Center(
//             child: Container(
//               width: 60,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),

//           Text(
//             'Shopping Cart',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 16),

//           if (_cartItems.isEmpty)
//             Column(
//               children: [
//                 Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey[400]),
//                 SizedBox(height: 16),
//                 Text(
//                   'Your cart is empty',
//                   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                 ),
//               ],
//             )
//           else
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = _cartItems[index];
//                   return _buildCartItem(item, index);
//                 },
//               ),
//             ),

//           if (_cartItems.isNotEmpty) ...[
//             SizedBox(height: 16),
//             _buildTotalSection(),
//             SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: widget.onCheckout,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF6D28D9),
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Proceed to Checkout - ₹${_totalAmount.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildCartItem(Map<String, dynamic> item, int index) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(12),
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Color(0xFF6D28D9).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Text(
//               item['image'],
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//         ),
//         title: Text(
//           item['name'],
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 4),
//             Text('₹${item['price']} each'),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.remove_rounded, size: 18),
//                   onPressed: () => _updateQuantity(index, item['quantity'] - 1),
//                   padding: EdgeInsets.zero,
//                   constraints: BoxConstraints(),
//                 ),
//                 Container(
//                   width: 30,
//                   alignment: Alignment.center,
//                   child: Text(
//                     item['quantity'].toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add_rounded, size: 18),
//                   onPressed: () => _updateQuantity(index, item['quantity'] + 1),
//                   padding: EdgeInsets.zero,
//                   constraints: BoxConstraints(),
//                 ),
//                 Spacer(),
//                 Text(
//                   '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF6D28D9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
//           onPressed: () => _removeItem(index),
//         ),
//       ),
//     );
//   }

//   Widget _buildTotalSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildTotalRow('Subtotal', _totalAmount),
//             _buildTotalRow('Shipping', 5.99),
//             _buildTotalRow('Tax', _totalAmount * 0.08),
//             Divider(),
//             _buildTotalRow('Total', _totalAmount + 5.99 + (_totalAmount * 0.08), isTotal: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: isTotal ? Colors.grey[600] : Colors.grey[600],
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Spacer(),
//           Text(
//             '₹${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 18 : 14,
//               color: isTotal ? Color(0xFF6D28D9) : Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CheckoutScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalAmount;
//   final VoidCallback onOrderPlaced;
//   final String? sparePartEmail;

//   const CheckoutScreen({
//     super.key,
//     required this.cartItems,
//     required this.totalAmount,
//     required this.onOrderPlaced,
//     this.sparePartEmail,
//   });

//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _zipController = TextEditingController();

//   String _selectedPaymentMethod = 'Credit Card';
//   bool _isLoading = false;

//   final List<String> _paymentMethods = [
//     'Credit Card',
//     'Debit Card',
//     'PayPal',
//     'Cash on Delivery',
//     'RuPay',
//   ];

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     // Pre-fill email if available from spareparts
//     if (widget.sparePartEmail != null) {
//       _emailController.text = widget.sparePartEmail!;
//     }
//   }

//   Future<void> _placeOrder() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       // Use email from spareparts collection if available, otherwise use user email or form email
//       final userEmail = widget.sparePartEmail ?? user?.email ?? _emailController.text.trim();

//       final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
//       final totalWithShipping = widget.totalAmount + 5.99 + (widget.totalAmount * 0.08);

//       // Create order data map
//       final orderData = {
//         'orderId': orderId,
//         'name': _nameController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'email': userEmail,
//         'address': _addressController.text.trim(),
//         'city': _cityController.text.trim(),
//         'zip': _zipController.text.trim(),
//         'paymentMethod': _selectedPaymentMethod,
//         'cartItems': widget.cartItems,
//         'subtotal': widget.totalAmount,
//         'shipping': 5.99,
//         'tax': widget.totalAmount * 0.08,
//         'total': totalWithShipping,
//         'timestamp': FieldValue.serverTimestamp(),
//         'status': 'Pending',
//         'sparePartEmail': widget.sparePartEmail, // Store the original spare part email
//       };

//       // Write to Firestore under: garage → userEmail → shop → new order doc
//       await _firestore
//           .collection('garage')
//           .doc(userEmail)
//           .collection('shop')
//           .doc(orderId)
//           .set(orderData);

//       setState(() => _isLoading = false);

//       // Show confirmation
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           title: const Text('Order Placed Successfully 🎉'),
//           content: Text('Your Order ID: $orderId\n\nTotal: ₹${totalWithShipping.toStringAsFixed(2)}\n\nEmail: $userEmail'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 widget.onOrderPlaced();
//                 Navigator.pop(context); // close dialog
//                 Navigator.pop(context); // go back
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to place order: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalWithShipping = widget.totalAmount + 5.99 + (widget.totalAmount * 0.08);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: const Color(0xFF6D28D9),
//         foregroundColor: Colors.white,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildOrderSummary(),
//                     const SizedBox(height: 20),
//                     _buildShippingDetails(),
//                     const SizedBox(height: 20),
//                     _buildPaymentMethod(),
//                     const SizedBox(height: 30),
//                     _buildPlaceOrderButton(totalWithShipping),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildOrderSummary() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             ...widget.cartItems.map((item) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     children: [
//                       Expanded(child: Text('${item['name']} x${item['quantity']}')),
//                       Text('₹${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
//                     ],
//                   ),
//                 )),
//             const Divider(),

//             // Display email information
//             if (widget.sparePartEmail != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 child: Row(
//                   children: [
//                     Text('Seller Email:', style: TextStyle(fontWeight: FontWeight.w600)),
//                     SizedBox(width: 8),
//                     Expanded(child: Text(widget.sparePartEmail!)),
//                   ],
//                 ),
//               ),

//             _buildSummaryRow('Subtotal', widget.totalAmount),
//             _buildSummaryRow('Shipping', 5.99),
//             _buildSummaryRow('Tax', widget.totalAmount * 0.08),
//             const Divider(),
//             _buildSummaryRow('Total', widget.totalAmount + 5.99 + (widget.totalAmount * 0.08), isTotal: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? const Color(0xFF6D28D9) : Colors.grey[700],
//             ),
//           ),
//           const Spacer(),
//           Text(
//             '₹${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 16 : 14,
//               color: isTotal ? const Color(0xFF6D28D9) : Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShippingDetails() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Shipping Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             _buildTextField(_nameController, 'Full Name', Icons.person_rounded),
//             const SizedBox(height: 12),
//             _buildTextField(_phoneController, 'Phone Number', Icons.phone_rounded, keyboard: TextInputType.phone),
//             const SizedBox(height: 12),
//             _buildTextField(_emailController, 'Email Address', Icons.email_rounded),
//             const SizedBox(height: 12),
//             _buildTextField(_addressController, 'Address', Icons.home_rounded),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(child: _buildTextField(_cityController, 'City', Icons.location_city)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildTextField(_zipController, 'ZIP Code', Icons.pin_drop)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboard}) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       keyboardType: keyboard,
//       validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
//     );
//   }

//   Widget _buildPaymentMethod() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             ..._paymentMethods.map(
//               (method) => RadioListTile<String>(
//                 title: Text(method),
//                 value: method,
//                 groupValue: _selectedPaymentMethod,
//                 onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
//                 activeColor: const Color(0xFF6D28D9),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlaceOrderButton(double totalAmount) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _placeOrder,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF6D28D9),
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: Text(
//           'Place Order - ₹${totalAmount.toStringAsFixed(2)}',
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// // Order Confirmation Dialog
// class OrderConfirmationDialog extends StatelessWidget {
//   final String orderId;
//   final double totalAmount;
//   final VoidCallback onClose;

//   const OrderConfirmationDialog({
//     super.key,
//     required this.orderId,
//     required this.totalAmount,
//     required this.onClose,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
//             SizedBox(height: 16),
//             Text(
//               'Order Confirmed!',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Your order has been placed successfully.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
//             _buildDetailRow('Order ID', orderId),
//             _buildDetailRow('Total Amount', '\$${totalAmount.toStringAsFixed(2)}'),
//             _buildDetailRow('Estimated Delivery', '3-5 business days'),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: onClose,
//                     child: Text('Continue Shopping'),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       onClose();
//                       // Navigate to order tracking
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF6D28D9),
//                     ),
//                     child: Text('Track Order'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label:', style: TextStyle(fontWeight: FontWeight.w600)),
//           SizedBox(width: 8),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }
import 'package:smart_road_app/controller/sharedprefrence.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SparePartsStore extends StatefulWidget {
  const SparePartsStore({super.key});

  @override
  _SparePartsStoreState createState() => _SparePartsStoreState();
}

class _SparePartsStoreState extends State<SparePartsStore> {
  int _selectedCategory = 0;
  String _searchQuery = '';
  List<Map<String, dynamic>> _cartItems = [];
  double _cartTotal = 0.0;
  bool _isLoading = true;
  String? _userEmail;
  String? _sparePartEmail;

  final List<String> _categories = [
    'All',
    '2-Wheeler',
    '4-Wheeler',
    'Truck',
    'Accessories',
  ];
  final List<String> _categoryIcons = ['🏠', '🏍️', '🚗', '🚛', '🔧'];

  List<Map<String, dynamic>> _spareParts = [];
  final List<Map<String, dynamic>> _featuredParts = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _loadSpareParts();
    _loadFeaturedFromSpareParts();
  }

  Future<void> _loadUserData() async {
    try {
      String? userEmail = await AuthService.getUserEmail();
      setState(() {
        _userEmail = userEmail;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _userEmail = _auth.currentUser?.email;
      });
    }
  }

  Future<void> _loadSpareParts() async {
    try {
      if (_userEmail == null) {
        await _loadUserData();
      }

      final String? userEmail = _userEmail ?? _auth.currentUser?.email;

      if (userEmail == null) {
        print('No user email found');
        _loadLocalData();
        return;
      }

      print('Loading spare parts for user: $userEmail');

      final querySnapshot = await _firestore
          .collection('garage')
          .doc(userEmail)
          .collection('spareparts')
          .orderBy('createdAt', descending: true)
          .get();

      print('Found ${querySnapshot.docs.length} spare parts');

      setState(() {
        _spareParts = querySnapshot.docs.map((doc) {
          final data = doc.data();
          print('Processing part: ${data['name']}');

          final partEmail = data['email'] ?? userEmail;
          _sparePartEmail = partEmail;
          print('Part email: $partEmail');

          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'description': data['description'] ?? '',
            'price': (data['price'] ?? 0).toDouble(),
            'originalPrice':
                (data['originalPrice'] ?? (data['price'] ?? 0) * 1.2)
                    .toDouble(),
            'category': data['category'] ?? 'Accessories',
            'brand': data['brand'] ?? 'Generic',
            'rating': (data['rating'] ?? 4.0).toDouble(),
            'reviews': data['reviews'] ?? 0,
            'stock': data['stock'] ?? 0,
            'image': _getPartIcon(data['category'] ?? ''),
            'compatibility': _parseCompatibility(data['compatibleModels']),
            'warranty': data['warranty'] ?? '1 Year',
            'deliveryTime': data['deliveryTime'] ?? '2-3 days',
            'seller': _getSellerFromEmail(partEmail),
            'sellerRating': (data['sellerRating'] ?? 4.5).toDouble(),
            'isAvailable': data['isAvailable'] ?? true,
            'email': partEmail,
            'upiId': data['upiId'] ?? '',
          };
        }).toList();
        _isLoading = false;
      });
      print('Successfully loaded ${_spareParts.length} spare parts');
    } catch (e) {
      print('Error loading spare parts: $e');
      setState(() {
        _isLoading = false;
      });
      _loadLocalData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading spare parts: $e')));
    }
  }

  String _getSellerFromEmail(String email) {
    try {
      return email.split('@').first;
    } catch (e) {
      print('Error parsing seller from email: $e');
    }
    return 'Auto Parts Store';
  }

  String _getPartIcon(String category) {
    switch (category.toLowerCase()) {
      case '2-wheeler':
        return '🏍️';
      case '4-wheeler':
        return '🚗';
      case 'truck':
        return '🚛';
      case 'universal':
        return '🛠️';
      default:
        return '🔧';
    }
  }

  void _loadFeaturedFromSpareParts() {
    if (_spareParts.length >= 2) {
      setState(() {
        _featuredParts.clear();
        _featuredParts.addAll([
          {..._spareParts[0], 'tag': 'Popular', 'image': '🎯'},
          {..._spareParts[1], 'tag': 'Best Value', 'image': '🛠️'},
        ]);
      });
    } else if (_spareParts.isNotEmpty) {
      setState(() {
        _featuredParts.clear();
        _featuredParts.addAll(
          _spareParts
              .map((part) => {...part, 'tag': 'Featured', 'image': '🎯'})
              .toList(),
        );
      });
    } else {
      _loadLocalFeaturedData();
    }
  }

  void _loadLocalData() {
    print('Loading local fallback data');
    _spareParts = [
      {
        'id': '1',
        'name': 'Engine Oil - Synthetic',
        'description':
            'Premium synthetic engine oil for better performance and longer engine life',
        'price': 45.99,
        'originalPrice': 55.99,
        'category': '4-Wheeler',
        'brand': 'Shell',
        'rating': 4.5,
        'reviews': 128,
        'stock': 25,
        'image': '🛢️',
        'compatibility': ['Sedan', 'SUV', 'Hatchback'],
        'warranty': '1 Year',
        'deliveryTime': '2-3 days',
        'seller': 'AutoParts Pro',
        'sellerRating': 4.8,
        'isAvailable': true,
        'email': 'autoparts@example.com',
        'upiId': 'autoparts@upi',
      },
      {
        'id': '2',
        'name': 'Bike Chain Set',
        'description':
            'High-quality chain set for motorcycles with excellent durability',
        'price': 29.99,
        'originalPrice': 39.99,
        'category': '2-Wheeler',
        'brand': 'RK',
        'rating': 4.3,
        'reviews': 89,
        'stock': 15,
        'image': '⛓️',
        'compatibility': ['Sports Bike', 'Cruiser'],
        'warranty': '6 Months',
        'deliveryTime': '1-2 days',
        'seller': 'Bike Masters',
        'sellerRating': 4.6,
        'isAvailable': true,
        'email': 'bikemasters@example.com',
        'upiId': 'bikemasters@okaxis',
      },
    ];
    setState(() {
      _isLoading = false;
    });
  }

  void _loadLocalFeaturedData() {
    _featuredParts.addAll([
      {
        'id': 'f1',
        'name': 'Limited Offer - Brake Kit',
        'description': 'Complete brake kit with 40% discount',
        'price': 129.99,
        'originalPrice': 199.99,
        'category': '4-Wheeler',
        'image': '🎯',
        'tag': 'Limited Offer',
        'email': 'specialoffers@example.com',
        'upiId': 'specialoffers@ybl',
      },
      {
        'id': 'f2',
        'name': 'Bike Service Kit',
        'description': 'Complete maintenance kit for motorcycles',
        'price': 39.99,
        'originalPrice': 59.99,
        'category': '2-Wheeler',
        'image': '🛠️',
        'tag': 'Best Seller',
        'email': 'bikemasters@example.com',
        'upiId': 'bikemasters@okaxis',
      },
    ]);
  }

  List<String> _parseCompatibility(dynamic compatibility) {
    if (compatibility is List) {
      return compatibility.cast<String>();
    } else if (compatibility is String) {
      return compatibility.split(',').map((e) => e.trim()).toList();
    }
    return ['Universal Fit'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchBar(),
                  if (_featuredParts.isNotEmpty) _buildFeaturedSection(),
                  _buildCategoryTabs(),
                  _buildPartsGrid(),
                ],
              ),
            ),
      floatingActionButton: _cartItems.isNotEmpty ? _buildCartFAB() : null,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF6D28D9)),
          SizedBox(height: 16),
          Text(
            'Loading spare parts...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🛠️ Spare Parts Store',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            'Genuine Parts • Fast Delivery',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      backgroundColor: Color(0xFF6D28D9),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart_rounded),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      _cartItems.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: _showCart,
        ),
        IconButton(
          icon: Icon(Icons.history_rounded),
          onPressed: _showOrderHistory,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search spare parts...',
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6D28D9)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _featuredParts.length,
        itemBuilder: (context, index) {
          final part = _featuredParts[index];
          return Container(
            width: 280,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6D28D9).withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Text(
                    part['image'],
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          part['tag'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        part['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        part['description'],
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${part['price']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '₹${part['originalPrice']}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SafeArea(
      child: SizedBox(
        height: 120,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: availableWidth < 400 ? 16 : 36,
                vertical: 16,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final double itemWidth = _calculateItemWidth(availableWidth);

                return Container(
                  width: itemWidth,
                  margin: EdgeInsets.only(right: availableWidth < 400 ? 8 : 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: availableWidth < 400 ? 12 : 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedCategory == index
                            ? Color(0xFF6D28D9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _categoryIcons[index],
                            style: TextStyle(
                              fontSize: availableWidth < 400 ? 16 : 20,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _categories[index],
                            style: TextStyle(
                              fontSize: availableWidth < 400 ? 10 : 12,
                              fontWeight: FontWeight.w600,
                              color: _selectedCategory == index
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  double _calculateItemWidth(double availableWidth) {
    if (availableWidth < 320) return 70;
    if (availableWidth < 400) return 80;
    if (availableWidth < 500) return 90;
    return 100;
  }

  Widget _buildPartsGrid() {
    List<Map<String, dynamic>> filteredParts = _spareParts.where((part) {
      final matchesCategory =
          _selectedCategory == 0 ||
          part['category'] == _categories[_selectedCategory];
      final matchesSearch =
          _searchQuery.isEmpty ||
          part['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          part['description'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesCategory && matchesSearch;
    }).toList();

    return Padding(
      padding: EdgeInsets.all(16),
      child: filteredParts.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredParts.length,
              itemBuilder: (context, index) {
                final part = filteredParts[index];
                return _buildPartCard(part);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No parts found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try changing your search or filters',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartCard(Map<String, dynamic> part) {
    bool isInCart = _cartItems.any((item) => item['id'] == part['id']);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showPartDetails(part),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF6D28D9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(part['image'], style: TextStyle(fontSize: 30)),
                  ),
                ),
              ),
              SizedBox(height: 8),

              Text(
                part['name'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),

              Row(
                children: [
                  Text(
                    part['brand'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  Text('${part['rating']}', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(height: 4),

              Row(
                children: [
                  Text(
                    '₹${part['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '₹${part['originalPrice']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isInCart ? null : () => _addToCart(part),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.grey : Color(0xFF6D28D9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    isInCart ? 'Added to Cart' : 'Add to Cart',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartFAB() {
    return FloatingActionButton.extended(
      onPressed: _showCart,
      backgroundColor: Color(0xFF6D28D9),
      foregroundColor: Colors.white,
      icon: Icon(Icons.shopping_cart_rounded),
      label: Text(
        '₹${_cartTotal.toStringAsFixed(2)}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> part) {
    setState(() {
      _cartItems.add({...part, 'quantity': 1, 'addedAt': DateTime.now()});
      _updateCartTotal();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${part['name']} added to cart!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateCartTotal() {
    _cartTotal = _cartItems.fold(
      0.0,
      (total, item) => total + (item['price'] * item['quantity']),
    );
  }

  void _showPartDetails(Map<String, dynamic> part) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PartDetailsBottomSheet(
        part: part,
        onAddToCart: () => _addToCart(part),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CartBottomSheet(
        cartItems: _cartItems,
        onUpdateCart: _updateCart,
        onCheckout: _proceedToCheckout,
      ),
    );
  }

  void _updateCart(List<Map<String, dynamic>> updatedCart) {
    setState(() {
      _cartItems = updatedCart;
      _updateCartTotal();
    });
  }

  void _proceedToCheckout() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: _cartItems,
          totalAmount: _cartTotal,
          onOrderPlaced: _clearCart,
          sparePartEmail: _getSparePartEmailFromCart(),
          upiId: _getUPIIdFromCart(),
        ),
      ),
    );
  }

  String? _getSparePartEmailFromCart() {
    if (_cartItems.isNotEmpty) {
      return _cartItems.first['email'] ?? _sparePartEmail ?? _userEmail;
    }
    return _sparePartEmail ?? _userEmail;
  }

  String? _getUPIIdFromCart() {
    if (_cartItems.isNotEmpty) {
      return _cartItems.first['upiId'];
    }
    return null;
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _cartTotal = 0.0;
    });
  }

  void _showOrderHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order History - Coming Soon!'),
        backgroundColor: Color(0xFF6D28D9),
      ),
    );
  }
}

class PartDetailsBottomSheet extends StatelessWidget {

  const PartDetailsBottomSheet({
    super.key,
    required this.part,
    required this.onAddToCart,
  });
  final Map<String, dynamic> part;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF6D28D9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(part['image'], style: TextStyle(fontSize: 30)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      part['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      part['brand'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Text(
                '₹${part['price']}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D28D9),
                ),
              ),
              SizedBox(width: 8),
              Text(
                '₹${part['originalPrice']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${((part['originalPrice'] - part['price']) / part['originalPrice'] * 100).toStringAsFixed(0)}% OFF',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                '${part['rating']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Text(
                '(${part['reviews']} reviews)',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Spacer(),
              Icon(Icons.inventory_2_rounded, color: Colors.blue, size: 20),
              SizedBox(width: 4),
              Text(
                '${part['stock']} in stock',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 16),

          Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            part['description'],
            style: TextStyle(color: Colors.grey[700], height: 1.5),
          ),
          SizedBox(height: 16),

          _buildSpecItem('Category', part['category']),
          _buildSpecItem('Compatibility', part['compatibility'].join(', ')),
          _buildSpecItem('Warranty', part['warranty']),
          _buildSpecItem('Delivery', part['deliveryTime']),
          _buildSpecItem(
            'Seller',
            '${part['seller']} ⭐ ${part['sellerRating']}',
          ),
          _buildSpecItem('Seller Email', part['email'] ?? 'Not specified'),
          if (part['upiId'] != null && part['upiId'].isNotEmpty)
            _buildSpecItem('Seller UPI ID', part['upiId']),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6D28D9),
                    side: BorderSide(color: Color(0xFF6D28D9)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Close'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onAddToCart();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6D28D9),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class CartBottomSheet extends StatefulWidget {

  const CartBottomSheet({
    super.key,
    required this.cartItems,
    required this.onUpdateCart,
    required this.onCheckout,
  });
  final List<Map<String, dynamic>> cartItems;
  final Function(List<Map<String, dynamic>>) onUpdateCart;
  final VoidCallback onCheckout;

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  late List<Map<String, dynamic>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
    } else {
      setState(() {
        _cartItems[index]['quantity'] = newQuantity;
      });
      widget.onUpdateCart(_cartItems);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    widget.onUpdateCart(_cartItems);
  }

  double get _totalAmount {
    return _cartItems.fold(
      0.0,
      (total, item) => total + (item['price'] * item['quantity']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),

          Text(
            'Shopping Cart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          if (_cartItems.isEmpty)
            Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return _buildCartItem(item, index);
                },
              ),
            ),

          if (_cartItems.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildTotalSection(),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D28D9),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Proceed to Checkout - ₹${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFF6D28D9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(item['image'], style: TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          item['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('₹${item['price']} each'),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_rounded, size: 18),
                  onPressed: () => _updateQuantity(index, item['quantity'] - 1),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Container(
                  width: 30,
                  alignment: Alignment.center,
                  child: Text(
                    item['quantity'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_rounded, size: 18),
                  onPressed: () => _updateQuantity(index, item['quantity'] + 1),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Spacer(),
                Text(
                  '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
          onPressed: () => _removeItem(index),
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', _totalAmount),
            _buildTotalRow('Shipping', 5.99),
            _buildTotalRow('Tax', _totalAmount * 0.08),
            Divider(),
            _buildTotalRow(
              'Total',
              _totalAmount + 5.99 + (_totalAmount * 0.08),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.grey[600] : Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Spacer(),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Color(0xFF6D28D9) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.onOrderPlaced,
    this.sparePartEmail,
    this.upiId,
  });
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final VoidCallback onOrderPlaced;
  final String? sparePartEmail;
  final String? upiId;

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String _selectedPaymentMethod = 'UPI Payment';
  bool _isLoading = false;
  bool _showUPIPayment = false;
  bool _paymentCompleted = false;

  final List<String> _paymentMethods = [
    'UPI Payment',
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Cash on Delivery',
    'RuPay',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.sparePartEmail != null) {
      _emailController.text = widget.sparePartEmail!;
    }
    _showUPIPayment = (_selectedPaymentMethod == 'UPI Payment');
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userEmail =
          widget.sparePartEmail ?? user?.email ?? _emailController.text.trim();

      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      final totalWithShipping =
          widget.totalAmount + 5.99 + (widget.totalAmount * 0.08);

      final orderData = {
        'orderId': orderId,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': userEmail,
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'zip': _zipController.text.trim(),
        'paymentMethod': _selectedPaymentMethod,
        'cartItems': widget.cartItems,
        'subtotal': widget.totalAmount,
        'shipping': 5.99,
        'tax': widget.totalAmount * 0.08,
        'total': totalWithShipping,
        'timestamp': FieldValue.serverTimestamp(),
        'status': _paymentCompleted ? 'Paid' : 'Pending',
        'sparePartEmail': widget.sparePartEmail,
        'upiId': widget.upiId,
        'paymentStatus': _paymentCompleted ? 'Completed' : 'Pending',
      };

      await _firestore
          .collection('garage')
          .doc(userEmail)
          .collection('shop')
          .doc(orderId)
          .set(orderData);

      setState(() => _isLoading = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            _paymentCompleted ? 'Payment Successful! 🎉' : 'Order Placed! 🎉',
          ),
          content: Text(
            _paymentCompleted
                ? 'Your payment has been processed successfully!\n\nOrder ID: $orderId\nTotal: ₹${totalWithShipping.toStringAsFixed(2)}\nPayment Method: $_selectedPaymentMethod'
                : 'Your order has been placed successfully!\n\nOrder ID: $orderId\nTotal: ₹${totalWithShipping.toStringAsFixed(2)}\nPayment Method: $_selectedPaymentMethod',
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.onOrderPlaced();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    }
  }

  void _handlePaymentSelection(String method) {
    setState(() {
      _selectedPaymentMethod = method;
      _showUPIPayment = (method == 'UPI Payment');
      _paymentCompleted = false;
    });
  }

  void _openUPIApp() async {
    if (widget.upiId == null || widget.upiId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('UPI ID not available')));
      return;
    }

    final totalWithShipping =
        widget.totalAmount + 5.99 + (widget.totalAmount * 0.08);
    final upiUrl =
        'upi://pay?pa=${widget.upiId}&pn=SpareParts Store&am=${totalWithShipping.toStringAsFixed(2)}&cu=INR';

    try {
      if (await canLaunchUrl(Uri.parse(upiUrl))) {
        await launchUrl(Uri.parse(upiUrl));

        // Show payment confirmation dialog
        _showPaymentConfirmationDialog(totalWithShipping);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No UPI app found. Please install a UPI app like GPay, PhonePe, or Paytm.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error launching UPI app: $e')));
    }
  }

  void _showPaymentConfirmationDialog(double totalAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Payment Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Have you completed the payment?'),
            SizedBox(height: 16),
            Text('Amount: ₹${totalAmount.toStringAsFixed(2)}'),
            Text('UPI ID: ${widget.upiId}'),
            SizedBox(height: 16),
            Text(
              'Please complete the payment in your UPI app and then confirm below.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _markPaymentAsPending();
            },
            child: Text('Payment Failed'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _paymentCompleted = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Payment confirmed! Click "Place Order" to complete your order.',
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 5),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Payment Successful'),
          ),
        ],
      ),
    );
  }

  void _markPaymentAsPending() {
    setState(() {
      _paymentCompleted = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment marked as pending. You can retry payment.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Generate UPI QR Code data
  String _generateUPIQrData() {
    final totalWithShipping =
        widget.totalAmount + 5.99 + (widget.totalAmount * 0.08);
    return 'upi://pay?pa=${widget.upiId}&pn=SpareParts Store&am=${totalWithShipping.toStringAsFixed(2)}&cu=INR';
  }

  @override
  Widget build(BuildContext context) {
    final totalWithShipping =
        widget.totalAmount + 5.99 + (widget.totalAmount * 0.08);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(),
                    const SizedBox(height: 20),
                    _buildShippingDetails(),
                    const SizedBox(height: 20),
                    _buildPaymentMethod(),
                    if (_showUPIPayment &&
                        widget.upiId != null &&
                        widget.upiId!.isNotEmpty)
                      _buildUPIPaymentSection(totalWithShipping),
                    const SizedBox(height: 20),
                    _buildPaymentStatus(),
                    const SizedBox(height: 20),
                    _buildPlaceOrderButton(totalWithShipping),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...widget.cartItems.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${item['name']} x${item['quantity']}'),
                    ),
                    Text(
                      '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),

            if (widget.sparePartEmail != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Seller Email:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text(widget.sparePartEmail!)),
                  ],
                ),
              ),

            if (widget.upiId != null && widget.upiId!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Seller UPI ID:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text(widget.upiId!)),
                  ],
                ),
              ),

            _buildSummaryRow('Subtotal', widget.totalAmount),
            _buildSummaryRow('Shipping', 5.99),
            _buildSummaryRow('Tax', widget.totalAmount * 0.08),
            const Divider(),
            _buildSummaryRow(
              'Total',
              widget.totalAmount + 5.99 + (widget.totalAmount * 0.08),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF6D28D9) : Colors.grey[700],
            ),
          ),
          const Spacer(),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? const Color(0xFF6D28D9) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextField(_nameController, 'Full Name', Icons.person_rounded),
            const SizedBox(height: 12),
            _buildTextField(
              _phoneController,
              'Phone Number',
              Icons.phone_rounded,
              keyboard: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _emailController,
              'Email Address',
              Icons.email_rounded,
            ),
            const SizedBox(height: 12),
            _buildTextField(_addressController, 'Address', Icons.home_rounded),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _cityController,
                    'City',
                    Icons.location_city,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _zipController,
                    'ZIP Code',
                    Icons.pin_drop,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: keyboard,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._paymentMethods.map(
              (method) => RadioListTile<String>(
                title: Text(method),
                value: method,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) => _handlePaymentSelection(value!),
                activeColor: const Color(0xFF6D28D9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPIPaymentSection(double totalAmount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'UPI Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // UPI ID Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seller UPI ID:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.qr_code, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.upiId!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.content_copy, color: Colors.green),
                        onPressed: () {
                          // Copy to clipboard functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('UPI ID copied to clipboard'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // QR Code Scanner Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  Text(
                    'Scan QR Code to Pay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // QR Code Display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: _generateUPIQrData(),
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D28D9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SpareParts Store',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Alternative Payment Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openUPIApp,
                      icon: Icon(Icons.payment),
                      label: Text('Open UPI App to Pay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionStep('1. Scan the QR code with any UPI app'),
                  _buildInstructionStep(
                    '2. Or click "Open UPI App to Pay" for direct payment',
                  ),
                  _buildInstructionStep('3. Complete payment in your UPI app'),
                  _buildInstructionStep(
                    '4. Return to this app and confirm payment',
                  ),
                  _buildInstructionStep('5. Click "Place Order" to complete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus() {
    if (_selectedPaymentMethod != 'UPI Payment') return SizedBox();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _paymentCompleted ? Icons.check_circle : Icons.pending_actions,
              color: _paymentCompleted ? Colors.green : Colors.orange,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _paymentCompleted ? 'Payment Completed' : 'Payment Pending',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _paymentCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                  Text(
                    _paymentCompleted
                        ? 'Your UPI payment has been confirmed'
                        : 'Please complete the UPI payment to proceed',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(double totalAmount) {
    bool canPlaceOrder =
        _selectedPaymentMethod != 'UPI Payment' || _paymentCompleted;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canPlaceOrder ? _placeOrder : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canPlaceOrder
              ? const Color(0xFF6D28D9)
              : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          canPlaceOrder
              ? 'Place Order - ₹${totalAmount.toStringAsFixed(2)}'
              : 'Complete Payment First',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
