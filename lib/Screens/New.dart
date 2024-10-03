import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';
import 'package:furnimitra/Screens/Notifications.dart';
import 'package:furnimitra/Screens/Profile.dart';
import 'package:furnimitra/Services/Mongo_service.dart';

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  final List<Map<String, String>> inspirationItems = [
    {
      "image": "assets/images/food.jpg",
      "text": "All you need to enjoy amchi mumbai food",
    },
    {
      "image": "assets/images/christmas.jpg",
      "text": "Getting the Christmas spirit in your home",
    },
    {
      "image": "assets/images/living.jpg",
      "text": "Lounge your way to the perfect school-life balance",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Profile()),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/svg/person.svg',
                      width: 27.0,
                      height: 27.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const notification()),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/svg/bell.svg',
                      width: 27.0,
                      height: 27.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "New From US",
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 26),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 60,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "New special prices",
                    style: TextStyle(color: Colors.white, fontSize: 21, fontFamily: 'Roboto'),
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),

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

                    final saleTab = saleTabb.skip(15).toList();

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
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "Get Inspired",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Inspiration from furnimitra",
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 26),
              ),
            ),
            SizedBox(height: 20),

            // Horizontal scroll for inspiration items
            SizedBox(
              height: 300, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: inspirationItems.length,
                itemBuilder: (context, index) {
                  final item = inspirationItems[index];
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            item["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text(
                              item["text"]!,
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
             SvgPicture.asset(
              'assets/svg/love.svg',
              width: MediaQuery.of(context).size.height * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
