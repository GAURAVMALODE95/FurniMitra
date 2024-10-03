import 'package:bloc/bloc.dart';
import 'package:furnimitra/Bloc/FavBloc/favevent.dart';
import 'package:furnimitra/Bloc/FavBloc/favstate.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    // Handle toggle favorite event
    on<ToggleFavoriteEvent>(_toggleFavorite);

    // Handle load favorites event
    on<LoadFavoritesEvent>(_loadFavorites);

    // Trigger loading of favorites on initialization
    add(LoadFavoritesEvent());
  }


Future<void> _toggleFavorite(ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> favoritesIds = prefs.getStringList('favorites') ?? [];

  // Convert the ObjectId to a String
  String productId = event.product['_id'].toString(); // Convert ObjectId to String

  if (favoritesIds.contains(productId)) {
    favoritesIds.remove(productId); // Remove from favorites
  } else {
    favoritesIds.add(productId); // Add to favorites
  }

  // Persist the updated favorites list
  await prefs.setStringList('favorites', favoritesIds);

  // Update the favorites in the state
  List<Map<String, dynamic>> updatedFavorites = (state is FavoritesLoaded)
      ? List.from((state as FavoritesLoaded).favorites)
      : [];

  // Add or remove the product from the in-memory list of favorite products
  if (updatedFavorites.any((element) => element['_id'].toString() == productId)) {
    updatedFavorites.removeWhere((element) => element['_id'].toString() == productId);
  } else {
    updatedFavorites.add(event.product);
  }

  emit(FavoritesLoaded(updatedFavorites));
}
  // Load favorites method
  Future<void> _loadFavorites(LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesIds = prefs.getStringList('favorites') ?? [];

    // Assuming you have a method to fetch products from your backend/database by IDs
    List<Map<String, dynamic>> favoriteProducts = await fetchFavoriteProductsByIds(favoritesIds);

    emit(FavoritesLoaded(favoriteProducts));
  }

  // Mock function: Replace this with actual logic to fetch product data by IDs from MongoDB or other service
  Future<List<Map<String, dynamic>>> fetchFavoriteProductsByIds(List<String> ids) async {
    return []; // Replace with actual data fetching logic
  }
}
