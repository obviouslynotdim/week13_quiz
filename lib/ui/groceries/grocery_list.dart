import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  // select index and filter
  int _selectpageindex = 0;
  String _searchquery = '';

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  // state selectedpage
  void _selectedPage(int index) {
    setState(() {
      _selectpageindex = index;
      if (index == 0) {
        _searchquery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // filter item match search query
    final filteredItems = dummyGroceryItems.where((item) {
      return item.name.toLowerCase().contains(_searchquery.toLowerCase());
    }).toList();

    // list displayitem
    List itemsTodisplay;
    if (_selectpageindex == 0) {
      itemsTodisplay = dummyGroceryItems;
    } else {
      itemsTodisplay = filteredItems;
    }

    Widget content = const Center(child: Text('No items added yet.'));

    // dummy to item
    if (itemsTodisplay.isNotEmpty) {
      //  Display groceries with an Item builder and  LIst Tile
      content = ListView.builder(
        itemCount: itemsTodisplay.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: itemsTodisplay[index]),
      );
    }

    Widget activePage = content;

    if (_selectpageindex == 1) {
      activePage = Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Filter by name...',
                prefixIcon: Icon(Icons.search),
              ),

              onChanged: (value) {
                setState(() {
                  _searchquery = value;
                });
              },
            ),
          ),
          const Divider(),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectpageindex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: "Groceries",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
