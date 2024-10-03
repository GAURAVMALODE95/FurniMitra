import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';
import 'package:furnimitra/Screens/Notifications.dart';
import 'package:furnimitra/Screens/Profile.dart';
import 'package:furnimitra/Screens/stores_screen.dart';
 
import 'package:furnimitra/Services/Mongo_service.dart';

class Stores extends StatefulWidget {
  const Stores({super.key});

  @override
  State<Stores> createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  String selectedStoreName = 'FurniMitra Mumbai';  // Default store name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity, // Full width of the screen
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 222, 235, 241), // Light blue background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Profile()));
                          },
                          child: SvgPicture.asset(
                            'assets/svg/person.svg',
                            width: 27.0,
                            height: 27.0,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const notification()));
                          },
                          child: SvgPicture.asset(
                            'assets/svg/bell.svg',
                            width: 27.0,
                            height: 27.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16,
                        top: 25), // Adjust padding to remove top and side gaps
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Start your store Visit",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 13),
                        GestureDetector(
                          onTap: () async {
                            // Navigate to StoresPage and wait for the selected store name
                            final selectedStore = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StoresPage()),
                            );

                            // If a store is selected, update the store name
                            if (selectedStore != null) {
                              setState(() {
                                print(selectedStore);
                                selectedStoreName = selectedStore;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                selectedStoreName,  // Display the selected store name
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "A little busy",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 10.0, // Width of the dot
                              height: 10.0, // Height of the dot
                              decoration: const BoxDecoration(
                                color: Colors.green, // Dot color
                                shape: BoxShape.circle, // Make it a circle
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Closes 10:00 pm",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            Column(
                              children: [
                                Icon(Icons.people),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Popular time")
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Icon(Icons.info),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Store info")
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Store Offers and Deals",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, fontFamily: 'Roboto'),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Horizontal List for sale items (bestsellers)
           FutureBuilder<List<Map<String, dynamic>>>(
                future:
                    MongoService.fetchsale(), // Fetch sale data from MongoDB
                builder: (context, saleSnapshot) {
                  if (saleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (saleSnapshot.hasError) {
                    return Center(child: Text('Error: ${saleSnapshot.error}'));
                  } else if (saleSnapshot.hasData &&
                      saleSnapshot.data!.isNotEmpty) {
                     final saleTabb = saleSnapshot.data!;

                    final saleTab = saleTabb.skip(10).toList();

                    return SizedBox(
                      height: 250, // Adjusted height for the list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: saleTab.length,
                        itemBuilder: (context, index) {
                          var saleItem = saleTab[index];
                          String priceText = saleItem['Price'] ?? 'N/A';
                          List<String> priceParts = priceText.split(' ');

                          return Container(
                            width: 150, // Fixed width
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Stack for Image and Heart Icon
                                Stack(
                                  children: [
                                    // Image section
                                    SizedBox(
                                      height: 150, // Fixed height for the image
                                      width: double
                                          .infinity, // Full width of the container
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: saleItem[
                                                  'Main Image URL'] ??
                                              'https://placehold.co/150x120',
                                          placeholder: (context, url) =>
                                              const SizedBox.shrink(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    // Heart icon in the bottom-right corner of the image
                                    // Heart icon in the bottom-right corner of the image
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Dispatch ToggleFavoriteEvent when the heart icon is tapped
                                          context.read<FavoritesBloc>().add(
                                              ToggleFavoriteEvent(saleItem));
                                        },
                                        child: BlocBuilder<FavoritesBloc,
                                            FavoritesState>(
                                          builder: (context, state) {
                                            bool isFavorite = false;

                                            if (state is FavoritesLoaded) {
                                              // Check if the current item is in the favorites list
                                              isFavorite = state.favorites.any(
                                                  (fav) =>
                                                      fav['_id'] ==
                                                      saleItem['_id']);
                                            }

                                            return Container(
                                              padding: const EdgeInsets.all(
                                                  6.0), // Padding for the heart icon inside the circle
                                              decoration: BoxDecoration(
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
                                  saleItem['Product Name'] ?? 'Unnamed Item',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  saleItem['Image Alt Text'] ?? '',
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
                                        text: priceParts[0] + ' ', // Rs part
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0, // Rs font size
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            priceParts[1], // Price part (6990)
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0, // Price font size
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
                        child: Text('No sale items available.'));
                  }
              },
            ),
            const SizedBox(height: 20),
            SvgPicture.asset(
              'assets/svg/shopping.svg',
              width: MediaQuery.of(context).size.height * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}