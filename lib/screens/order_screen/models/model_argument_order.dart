import 'package:Talabat/screens/currency_screen/models/model_currency.dart';
import 'package:Talabat/screens/sign_up_screen/models/model_user.dart';
import 'model_order.dart';
import 'model_order_items.dart';

class OrderArgument {
  final int id;
  final Order order;
  final User user;
  final CurrencyPage currency;
  OrderArgument(
      {required this.id,
      required this.user,
      required this.currency,
      required this.order,
      });
}
