import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furnimitra/Bloc/PriceBloc/priceevent.dart';
import 'package:furnimitra/Bloc/PriceBloc/pricestate.dart';
class PriceBloc extends Bloc<PriceEvent, PriceState> {
  PriceBloc() : super(PriceInitial()) {
    on<CalculateTotalEvent>((event, emit) {
      final double subtotal = event.subtotal.toDouble(); // Convert int to double
      final double deliveryCost = 749.0; // Make delivery cost double
      final double totalCostExclGST = subtotal + deliveryCost;
      final double gst = totalCostExclGST * 0.18; // 18% GST
      final double totalInclGST = totalCostExclGST + gst;

      emit(PriceCalculated(
        subtotal: subtotal,
        deliveryCost: deliveryCost,
        totalCostExclGST: totalCostExclGST,
        gst: gst,
        totalInclGST: totalInclGST,
      ));
    });
  }
}