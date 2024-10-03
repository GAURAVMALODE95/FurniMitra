import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // If you're using Bloc
import 'package:cached_network_image/cached_network_image.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';

// Assuming you have a FavoritesBloc that stores liked products
class Lists extends StatefulWidget {
  const Lists({super.key});

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Find and Save What You Liked",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Find Your all Favourites at One Place",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 200, 198, 198),
                ),
              ),
              const SizedBox(height: 20),

              // BlocBuilder to fetch liked products from your FavoritesBloc
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoaded) {
                    if (state.favorites.isNotEmpty) {
                      // If there are liked products, display them in a grid
                      final likedProducts = state.favorites;

                      return Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 items per row
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.8, // Adjust for image height
                          ),
                          itemCount: likedProducts.length,
                          itemBuilder: (context, index) {
                            var product = likedProducts[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: product['Main Image URL'] ?? 'https://placehold.co/150x120',
                                      placeholder: (context, url) => const SizedBox.shrink(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 190, // Set a fixed height for images
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product['Product Name'] ?? 'Unnamed Product',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // If no liked products, display the fallback text and message
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Add to Lists",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
