import 'package:flutter/material.dart';
import 'package:furnimitra/Services/Mongo_service.dart';

class StoresPage extends StatefulWidget {
  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  late Future<List<Map<String, dynamic>>> futureStores;

  @override
  void initState() {
    super.initState();
    futureStores = fetchStoresData();
  }

  Future<List<Map<String, dynamic>>> fetchStoresData() async {
    await MongoService.connect(); // Connect to MongoDB
    return MongoService.fetchstores(); // Fetch the list of stores
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureStores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No stores available'));
          }

          final stores = snapshot.data!;

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Current store',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              _buildStoreCard(stores[0], true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Other Furnimitra stores',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              ...stores.skip(1).map((store) => _buildStoreCard(store, false)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store, bool isCurrentStore) {
    var location = store['location'] ?? {};

    return GestureDetector(
      onTap: () {
        // On tap, return the selected store name and pop the screen
        Navigator.pop(context, location['name']); // Pass the store name back
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isCurrentStore ? Colors.blue : Colors.grey.shade300,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store name and Info Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    location['name'] ?? 'Unknown Store',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.info_outline,
                      color: const Color.fromARGB(255, 69, 68, 68)),
                ],
              ),
              SizedBox(height: 8),
              // Store Address
              Text(
                location['address'] ?? 'Address not available',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              // Store open status and closing time
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Open ',
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(text: '• Closes 10:00 pm'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
