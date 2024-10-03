import 'package:equatable/equatable.dart';

// Define the events related to the FavoritesBloc
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

// Event to toggle favorite status of a product
class ToggleFavoriteEvent extends FavoritesEvent {
  final Map<String, dynamic> product;

  const ToggleFavoriteEvent(this.product);

  @override
  List<Object> get props => [product];
}

// Event to load the list of favorites from storage
class LoadFavoritesEvent extends FavoritesEvent {
  @override
  List<Object> get props => [];
}
