import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static var db,
      productsTabCollection,
      productsCollection,
      SuggestCollection,
      roomstabcollection,
      salescollection,
      salecollection,
      newcollection,
      ideascollection,
      storesCollection;

  static connect() async {
    db = await mongo.Db.create(
        "mongodb+srv://gauravmalode777:v8fef4letVZGsC8O@cluster01.tnnc4.mongodb.net/Furnimitra?retryWrites=true&w=majority");
    await db.open();
    productsTabCollection = db.collection('Products_Tab');
    productsCollection = db.collection('Products');
    roomstabcollection = db.collection('Rooms_Tab');
    salescollection = db.collection('Sale');
    storesCollection = db.collection('Store');
    newcollection = db.collection('New');
    ideascollection = db.collection('Ideas');
    SuggestCollection = db.collection('Suggest');
  }

  static Future<List<Map<String, dynamic>>> fetchProductsTab() async {
    final productsTab = await productsTabCollection.find().toList();
    return productsTab;
  }

  static Future<List<Map<String, dynamic>>> fetchSuggest() async {
    final Suggest = await SuggestCollection.find().toList();
    return Suggest;
  }

  static Future<Map<String, dynamic>?> fetchProductByName(
      String productName) async {
    var collection = db.collection('Products');

    var product =
        await collection.findOne(where.eq('Product Name', productName));

    return product; // Return the product data
  }

  static Future<List<Map<String, dynamic>>> fetchProducts(
      List<String> subcategories) async {
    if (kDebugMode) {
      print("Fetching products for subcategories: $subcategories");
    }

    final products = await productsCollection.find({
      "Category": {
        // Ensure this matches the actual field in your product documents
        "\$in":
            subcategories, // Use the $in operator to match against multiple subcategories
      }
    }).toList();

    if (kDebugMode) {
      print("Number of products fetched: ${products.length}");
    }

    return products;
  }

  static Future<List<Map<String, dynamic>>> fetchroomstab() async {
    final roomstab = await roomstabcollection.find().toList();
    return roomstab;
  }

  static Future<List<Map<String, dynamic>>> fetchsale() async {
    final sale = await salescollection.find().toList();
    return sale;
  }

  static Future<List<Map<String, dynamic>>> fetchstores() async {
    final stores = await storesCollection.find().toList();
    return stores;
  }

  static Future<List<Map<String, dynamic>>> fetchnew() async {
    final new_Pro = await storesCollection.find().toList();
    return new_Pro;
  }

  static Future<List<Map<String, dynamic>>> fetchideas() async {
    final ideas = await storesCollection.find().toList();
    return ideas;
  }
}
