import 'package:equatable/equatable.dart';

// Define the states that the FavoritesBloc can emit
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

// Initial state when no data is loaded
class FavoritesInitial extends FavoritesState {}

// State when the list of favorites is loaded
class FavoritesLoaded extends FavoritesState {
  final List<Map<String, dynamic>> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}
