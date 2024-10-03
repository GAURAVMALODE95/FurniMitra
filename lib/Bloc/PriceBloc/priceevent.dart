import 'package:flutter_bloc/flutter_bloc.dart';


abstract class PriceEvent {}

class CalculateTotalEvent extends PriceEvent {
  final int subtotal;
  CalculateTotalEvent(this.subtotal);
}