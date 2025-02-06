import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pro_model.dart';
import 'proDetails.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'rating';
  bool _showGrid = true;
  int _currentIndex = 0;

  final List<Pro> _services = [
    Pro(
      name: 'John Doe',
      title: 'Certified Yoga Instructor with 10 Years Experience',
      category: 'Fitness',
      price: 80.0,
      rating: 4.5,
      image: 'https://picsum.photos/200/150?random=1',
    ),
    Pro(
      name: 'Sarah Wilson',
      title: 'Personal Trainer & Nutrition Specialist',
      category: 'Fitness',
      price: 90.0,
      rating: 4.8,
      image: 'https://picsum.photos/200/150?random=2',
    ),
    Pro(
      name: 'Mike Johnson',
      title: 'Professional Hairstylist - Premium Services',
      category: 'Beauty',
      price: 75.0,
      rating: 4.3,
      image: 'https://picsum.photos/200/150?random=3',
    ),
    Pro(
      name: 'Emma Davis',
      title: 'Master Barber - Modern Haircuts & Styling',
      category: 'Beauty',
      price: 65.0,
      rating: 4.6,
      image: 'https://picsum.photos/200/150?random=4',
    ),
  ];

  List<Pro> get _filteredServices {
    List<Pro> results = _services.where((service) {
      final matchesCategory = _selectedCategory == 'All' ||
          service.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch =
          service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              service.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    results.sort((a, b) {
      switch (_sortBy) {
        case 'price':
          return a.price.compareTo(b.price);
        case 'rating':
          return b.rating.compareTo(a.rating);
        default:
          return a.name.compareTo(b.name);
      }
    });

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 390,
        height: 844,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1E120F28),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryFilters(),
            _buildSortingRow(),
            Expanded(child: _buildServiceGrid()),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          AppBar(
            title: Text('LocalPro'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.tune),
                onPressed: _showSortDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 43,
      margin: EdgeInsets.all(16),
      padding: const EdgeInsets.only(top: 9, left: 16, right: 16, bottom: 8),
      decoration: ShapeDecoration(
        color: Color(0xFFF3F4F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for services...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Color(0xFFBCC1CA)),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = ['All', 'Fitness', 'Beauty', 'Plumbing', 'Electrical'];

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) => setState(
                  () => _selectedCategory = selected ? category : 'All'),
              selectedColor: Color(0xFF0056B3),
              labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? Colors.white
                    : Color(0xFF323842),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredServices.length} Services Found',
            style: TextStyle(color: Color(0xFF0056B3), fontSize: 16),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.grid_view,
                    color: _showGrid ? Color(0xFF0056B3) : Colors.grey),
                onPressed: () => setState(() => _showGrid = true),
              ),
              IconButton(
                icon: Icon(Icons.list,
                    color: !_showGrid ? Color(0xFF0056B3) : Colors.grey),
                onPressed: () => setState(() => _showGrid = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid() {
    return _showGrid
        ? GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.5,
            ),
            itemCount: _filteredServices.length,
            itemBuilder: (context, index) =>
                _buildServiceCard(_filteredServices[index], isList: false),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredServices.length,
            itemBuilder: (context, index) =>
                _buildServiceCard(_filteredServices[index], isList: true),
          );
  }

  Widget _buildServiceCard(Pro pro, {bool isList = false}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProDetails(pro: pro));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFFBCC1CA), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isList ? 150 : 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    pro.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child:
                          Icon(Icons.person, size: 50, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                pro.name,
                style: TextStyle(
                  fontSize: isList ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171A1F),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                pro.title,
                style: TextStyle(
                  fontSize: isList ? 14 : 12,
                  color: Color(0xFF9095A0),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '${pro.rating}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$${pro.price}/hr',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0056B3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF0056B3),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFF0056B3)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Rating'),
              value: 'rating',
              groupValue: _sortBy,
              onChanged: (value) => setState(() {
                _sortBy = value!;
                Navigator.pop(context);
              }),
            ),
            RadioListTile<String>(
              title: Text('Price: Low to High'),
              value: 'price',
              groupValue: _sortBy,
              onChanged: (value) => setState(() {
                _sortBy = value!;
                Navigator.pop(context);
              }),
            ),
            RadioListTile<String>(
              title: Text('Name'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) => setState(() {
                _sortBy = value!;
                Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: Color(0xFF0056B3),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 3) {
          if (_services.isNotEmpty) {
            Get.to(() => ProDetails(pro: _services.first));
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
