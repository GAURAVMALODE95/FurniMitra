import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';
import 'package:furnimitra/Screens/Dashboard.dart';
import 'package:furnimitra/Screens/cat_map.dart';
import 'package:furnimitra/Screens/products_detail_page.dart';
import 'package:furnimitra/Services/Mongo_service.dart';
// import 'package:furnimitra/Services/Mongo_service2.dart';

class ProductPage extends StatefulWidget {
  final String imagelink;
  final String nameofpro;
  final List<String> subcategories;

  const ProductPage({
    Key? key,
    required this.imagelink,
    required this.nameofpro,
    required this.subcategories,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.imagelink,
                      height: MediaQuery.of(context).size.height * 0.29,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Positioned(
                      top: 10,
                      
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.nameofpro,
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.subcategories
                    .map((subcategory) => _buildContainer(subcategory))
                    .toList(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: const Divider(
                    color: Color.fromARGB(255, 100, 99, 99), thickness: 1.7),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 41, 41, 41),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping, color: Colors.white),
                      const SizedBox(width: 8.0),
                      Text(
                        'Show availability',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 19),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: MongoService.fetchProducts(widget.subcategories),
                builder: (context, saleSnapshot) {
                  if (saleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (saleSnapshot.hasError) {
                    return Center(child: Text('Error: ${saleSnapshot.error}'));
                  } else if (saleSnapshot.hasData) {
                    final saleTab = saleSnapshot.data!;
                    // Here we update the text with the number of products
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Showing ${saleTab.length} products", // Display the number of products
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 126, 126, 128),
                        ),
                      ),
                    );
                  } else {
                    // If no data, show default message
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Showing 0 products", // Default message if no products
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 126, 126, 128),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: MongoService.fetchProducts(widget.subcategories),
                builder: (context, saleSnapshot) {
                  if (saleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (saleSnapshot.hasError) {
                    return Center(child: Text('Error: ${saleSnapshot.error}'));
                  } else if (saleSnapshot.hasData &&
                      saleSnapshot.data!.isNotEmpty) {
                    final saleTab = saleSnapshot.data!;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: saleTab.length,
                      itemBuilder: (context, index) {
                        var saleItem = saleTab[index];
                        return _buildProductItem(context, saleItem);
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No sale items available.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each product item
  Widget _buildProductItem(
      BuildContext context, Map<String, dynamic> saleItem) {
    String priceText = saleItem['Price'] ?? 'N/A';
    List<String> priceParts = priceText.split(' ');

    return GestureDetector(
      onTap: (){
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            title: saleItem['Product Name'] ?? 'Unnamed Item',
            price: int.parse(priceParts[1]),

          ),
        ),
      );

      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: saleItem['Main Image URL'] ??
                          'https://placehold.co/150x120',
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<FavoritesBloc>()
                          .add(ToggleFavoriteEvent(saleItem));
                    },
                    child: BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, state) {
                        bool isFavorite = false;
                        if (state is FavoritesLoaded) {
                          isFavorite = state.favorites
                              .any((fav) => fav['_id'] == saleItem['_id']);
                        }
                        return Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.0),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
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
              style: const TextStyle(color: Colors.white, fontSize: 14.0),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: priceParts[0] + ' ',
                    style: const TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                  TextSpan(
                    text: priceParts[1],
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Add padding
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 41, 41, 41),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Color.fromARGB(255, 151, 145, 145), width: 2.0),
    ),
    alignment: Alignment.center,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 15),
    ),
  );
}

}
