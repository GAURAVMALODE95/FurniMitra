abstract class PriceState {}

class PriceInitial extends PriceState {}

class PriceCalculated extends PriceState {
  final double subtotal;
  final double deliveryCost;
  final double totalCostExclGST;
  final double gst;
  final double totalInclGST;

  PriceCalculated({
    required this.subtotal,
    required this.deliveryCost,
    required this.totalCostExclGST,
    required this.gst,
    required this.totalInclGST,
  });
}