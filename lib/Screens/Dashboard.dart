import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';
import 'package:furnimitra/Screens/Lists.dart';
import 'package:furnimitra/Screens/New.dart';
import 'package:furnimitra/Screens/Notifications.dart';
import 'package:furnimitra/Screens/Profile.dart';
import 'package:furnimitra/Screens/Search.dart';
import 'package:furnimitra/Screens/products_screen.dart';
import 'package:furnimitra/Screens/stores.dart';
import 'package:furnimitra/Services/Mongo_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1; // Set initial index to 1 to highlight Search icon

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const New(); // Show New screen when selected
      case 1:
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 17.0, right: 17.0),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you looking for?',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 2.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 1.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 190,
                          child: TabBar(
                            controller: _tabController,
                            indicatorColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            labelColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            unselectedLabelColor:
                                const Color.fromARGB(255, 66, 66, 66),
                            tabs: const [
                              Tab(text: 'Products'),
                              Tab(text: 'Rooms'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              Products(),
              Rooms(),
            ],
          ),
        );
      case 2:
        return const Lists(); // Show Liked screen when selected
      case 3:
        return const Stores(); // Show Stores screen when selected
      default:
        return const Search(); // Default is Search screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _getSelectedScreen(), // Show the selected screen
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 71, 70, 70),
          currentIndex: _selectedIndex, // Controls which icon is highlighted
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.wandMagicSparkles,
                size: 16,
              ),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Liked',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Stores',
            ),
          ],
        ),
      ),
    );
  }
}

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoService.fetchProductsTab(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final productsTab = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Vertical Grid Section for Products
              GridView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productsTab.length, // Dynamically set item count
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  var product = productsTab[index]; // Dynamic product data
                  return GestureDetector(
                    onTap: () {
                      var selectedSection =
                          productsTab[index]; // The section (e.g., Furniture)
                      List<String> subcategories =
                          selectedSection['subcategories'] != null
                              ? List<String>.from(
                                  selectedSection['subcategories'])
                              : []; // Get the subcategories array

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            imagelink: product['image'] ??
                                'https://placehold.co/100x100', // Pass the image
                            nameofpro: product['name'] ??
                                'Unnamed Product', // Pass the name
                            subcategories:
                                subcategories, // Pass the subcategories
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 44, 41, 41),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product['image'] ??
                                    'https://placehold.co/100x100',
                                placeholder: (context, url) =>
                                    const SizedBox.shrink(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // height: 200,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10, top: 11, bottom: 11),
                            child: Center(
                              child: Text(
                                product['name'], // Use name from MongoDB
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 194, 193, 193),
                                  fontFamily: 'Roboto',
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Horizontal Scroll Section for Bestsellers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Discover Bestsellers",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontFamily: 'Roboto'),
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
                    final saleTab = saleSnapshot.data!;

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
              )
            ],
          );
        } else {
          print("No products available.");
          return const Center(child: Text('No products available.'));
        }
      },
    );
  }
}

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  @override
  Widget build(BuildContext context) {
    // Starting FutureBuilder for Rooms
    print('Fetching room data...');

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoService.fetchroomstab(), // Fetch room data from MongoDB
      builder: (context, snapshot) {
        // Checking connection state
        print(
            'Room data snapshot connection state: ${snapshot.connectionState}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Still waiting for room data...');
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Print the error in case of failure
          print('Error occurred while fetching room data: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          print('Room data fetched successfully.');
          final roomsTab = snapshot.data!;
          print('Number of rooms fetched: ${roomsTab.length}');

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Vertical GridView for rooms (similar to Products)
              GridView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: roomsTab.length, // Number of items in the grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 15, // Spacing similar to Products
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  var room = roomsTab[index]; // Dynamic room data
                  print('Rendering room: ${room['name']}');

                  return Container(
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 34, 34, 34), // Darker color
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: room['image'] ??
                                  'https://placehold.co/100x100',
                              placeholder: (context, url) =>
                                  const SizedBox.shrink(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10,
                              top: 11,
                              bottom: 11), // Adjusted paddings like Products
                          child: Center(
                            child: Text(
                              room['name'] ??
                                  'Unnamed Room', // Use room name from MongoDB
                              style: const TextStyle(
                                color: Color.fromARGB(255, 194, 193, 193),
                                fontFamily: 'Roboto',
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Horizontal Scroll for Bestsellers (similar to Products)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Discover Bestsellers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 15),

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
                    final saleTab = saleSnapshot.data!;

                    return SizedBox(
                      height:
                          250, // Adjusted height for the list (increased to avoid clipping)
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
                                // Image section
                                SizedBox(
                                  height: 150, // Fixed height for the image
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: saleItem['Main Image URL'] ??
                                          'https://placehold.co/150x120',
                                      placeholder: (context, url) =>
                                          const SizedBox.shrink(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: double
                                          .infinity, // Ensures the image takes up full width
                                    ),
                                  ),
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

                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  saleItem['Image Alt Text'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),

                                SizedBox(
                                  height: 4,
                                ),
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
                                )
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
            ],
          );
        } else {
          print("No rooms available.");
          return const Center(child: Text('No rooms available.'));
        }
      },
    );
  }
}
