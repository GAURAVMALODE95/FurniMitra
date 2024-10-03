import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';
import 'package:furnimitra/Screens/buypage.dart';
import 'package:furnimitra/Services/Mongo_service.dart';

class ProductDetailPage extends StatelessWidget {
  final String title;
  final int price;
  const ProductDetailPage({Key? key, required this.title,required this.price}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<Map<String, dynamic>?>(
          future: MongoService.fetchProductByName(title),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No product found'));
            } else {
              var product = snapshot.data!;
              String priceText = product['Price'] ?? 'N/A';
              List<String> priceParts = priceText.split(' ');
              String Totalreview = product['Total Reviews'].toString();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: product['Main Image URL'],
                            height: MediaQuery.of(context).size.height * 0.29,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Positioned(
                            top: 10,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: const Color.fromARGB(255, 56, 55, 55),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: const Divider(
                        color: Color.fromARGB(255, 100, 99, 99),
                        thickness: 1.7,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        product['Product Name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 21.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        product['Image Alt Text'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 161, 160, 160),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: priceParts[0] + ' ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                            TextSpan(
                              text: priceParts[1],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 244, 244, 244),
                                fontSize: 28.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              'Customize it',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Text(
                            'Product Information',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    product['Rating'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '(${product['Total Reviews']})',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: const Divider(
                            color: Color.fromARGB(255, 100, 99, 99),
                            thickness: 1.7,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '117x176 cm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: const Divider(
                            color: Color.fromARGB(255, 100, 99, 99),
                            thickness: 1.7,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'More info',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Text(
                            'Delivery and Pickup',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.local_shipping, color: Colors.white),
                          title: Text(
                            'Home Delivery',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Available for 422003',
                            style: TextStyle(color: Colors.green),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Divider(
                            color: Color.fromARGB(255, 100, 99, 99),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.store, color: Colors.white),
                          title: Text(
                            'Click & Collect',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Available at Hyderabad',
                            style: TextStyle(color: Colors.green),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Divider(
                            color: Color.fromARGB(255, 100, 99, 99),
                          ),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.shopping_bag, color: Colors.white),
                          title: Text(
                            'Shop in store',
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Text(
                            'In stock in Hyderabad',
                            style: TextStyle(color: Colors.green),
                          ),
                          trailing:
                              Icon(Icons.expand_more, color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Add to Bag button
                            GestureDetector(
                              onTap: () {
                                // Add functionality for Add to Bag here
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 82, 178, 222),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Add to Bag',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            // Buy Now button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BuyPage(Price:price)),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                 color: Color.fromARGB(255, 82, 178, 222),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Buy Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "You may also like",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Roboto'),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: MongoService
                              .fetchSuggest(), // Fetch suggest data from MongoDB
                          builder: (context, suggestSnapshot) {
                            if (suggestSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (suggestSnapshot.hasError) {
                              return Center(
                                  child:
                                      Text('Error: ${suggestSnapshot.error}'));
                            } else if (suggestSnapshot.hasData &&
                                suggestSnapshot.data!.isNotEmpty) {
                              final suggestTabb = suggestSnapshot.data!;

                              final suggestTab = suggestTabb.toList();

                              return SizedBox(
                                height: 250, // Adjusted height for the list
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: suggestTab.length,
                                  itemBuilder: (context, index) {
                                    var suggestItem = suggestTab[index];
                                    String priceText =
                                        suggestItem['Price'] ?? 'N/A';
                                    List<String> priceParts =
                                        priceText.split(' ');

                                    return Container(
                                      width: 150, // Fixed width
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Stack for Image and Heart Icon
                                          Stack(
                                            children: [
                                              // Image section
                                              SizedBox(
                                                height:
                                                    150, // Fixed height for the image
                                                width: double
                                                    .infinity, // Full width of the container
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: suggestItem[
                                                            'Main Image URL'] ??
                                                        'https://placehold.co/150x120',
                                                    placeholder: (context,
                                                            url) =>
                                                        const SizedBox.shrink(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                              // Heart icon in the bottom-right corner of the image
                                              Positioned(
                                                bottom: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Dispatch ToggleFavoriteEvent when the heart icon is tapped
                                                    context
                                                        .read<FavoritesBloc>()
                                                        .add(
                                                            ToggleFavoriteEvent(
                                                                suggestItem));
                                                  },
                                                  child: BlocBuilder<
                                                      FavoritesBloc,
                                                      FavoritesState>(
                                                    builder: (context, state) {
                                                      bool isFavorite = false;

                                                      if (state
                                                          is FavoritesLoaded) {
                                                        // Check if the current item is in the favorites list
                                                        isFavorite = state
                                                            .favorites
                                                            .any((fav) =>
                                                                fav['_id'] ==
                                                                suggestItem[
                                                                    '_id']);
                                                      }

                                                      return Container(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            6.0), // Padding for the heart icon inside the circle
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .circle, // Circular shape
                                                          color: Colors
                                                              .white, // Background color of the circle (white)
                                                          border: Border.all(
                                                            color: Colors
                                                                .black, // Black border around the circle
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          isFavorite
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border, // Solid heart if favorite, else outline
                                                          color: isFavorite
                                                              ? Colors.red
                                                              : Colors
                                                                  .black, // Red if favorite, black otherwise
                                                          size: 24,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8.0),

                                          // Text section (product name)
                                          Text(
                                            suggestItem['Product Name'] ??
                                                'Unnamed Item',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),

                                          const SizedBox(height: 4),
                                          Text(
                                            suggestItem['Image Alt Text'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),

                                          const SizedBox(height: 4),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: priceParts[0] +
                                                      ' ', // Rs part
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        13.0, // Rs font size
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: priceParts[
                                                      1], // Price part (6990)
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        24.0, // Price font size
                                                  ),
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
                            } else {
                              return const Center(
                                  child: Text('No suggest items available.'));
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
