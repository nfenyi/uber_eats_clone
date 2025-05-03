import 'asset_names.dart';

class OtherConstants {
  const OtherConstants._();
  // final List<FoodCategory> _foodCategories = [
  //   FoodCategory('Breakfast', AssetNames.breakfast),
  //   FoodCategory('Coffee', AssetNames.coffee),
  //   FoodCategory('Pizza', AssetNames.pizza),
  //   FoodCategory('Grocery', AssetNames.grocery),
  //   FoodCategory('Fast Food', AssetNames.fastFood),
  //   FoodCategory('Chinese', AssetNames.chinese),
  //   FoodCategory('Healthy', AssetNames.healthy),
  //   FoodCategory('Sandwich', AssetNames.sandwich),
  //   FoodCategory('Mexican', AssetNames.mexican),
  //   FoodCategory('Sushi', AssetNames.sushi),
  //   FoodCategory('Korean', AssetNames.korean),
  //   FoodCategory('Donuts', AssetNames.donuts),
  //   FoodCategory('Indian', AssetNames.indian),
  // ];

  static const List<String> filters = [
    'Uber One',
    'Pickup',
    'Offers',
    'Delivery fee',
    'Rating',
    'Price',
    'Dietary',
    'Sort'
  ];

  static const billings = <Plan>[
    Plan(period: 'Monthly', bill: 9.99),
    Plan(period: 'Annual', bill: 8)
  ];

  static const double uberOneDiscount = 0.1;
  static const double tax = 0.05;
  static const double serviceFee = 0.4;

  static const List<String> boxCateringFilters = [
    'Group size',
    'Sort',
    'Offers',
    'Best overall'
  ];
  static const List<String> deliveryPriceFilters = ['\$1', '\$3', '\$5', '_'];
  static const List<String> sortOptions = ['Rating', 'Delivery time'];

  static const List<String> ratingsFilters = ['3+', '3.5+', '4+', '4.5+', '5'];
  static const List<String> pricesFilters = [
    '\$',
    '\$\$',
    '\$\$\$',
    '\$\$\$\$'
  ];

  static const String na = 'N/A';

  static final benefits = [
    UberOneBenefit(
        assetImage: AssetNames.uberOneGiftBag,
        title: '\$0 Delivery Fee',
        message:
            'Save on food, grocery, and other orders over the minimum subtotal'),
    UberOneBenefit(
        assetImage: AssetNames.uberOneTag,
        title: 'Up to 10% off orders',
        message:
            'Save on delivery and pickup orders over the minimum subtotal'),
    UberOneBenefit(
        assetImage: AssetNames.uberOneCar,
        title: '6% back on rides',
        message: 'Earn 6% Uber Cash and get top-rated drivers'),
    UberOneBenefit(
        assetImage: AssetNames.uberOneGiftBag,
        title: 'Exclusive offers',
        message: 'Member-only promos and special items'),
    UberOneBenefit(
        assetImage: AssetNames.oneHouse,
        title: 'Thousands of options',
        message: 'Save on your favorite restaurants and stores'),
    UberOneBenefit(
        assetImage: AssetNames.uberOneCalendar,
        title: 'Cancel anytime',
        message: 'Cancel your membership with no additional fees'),
  ];
}

class UberOneBenefit {
  final String assetImage;
  final String title;
  final String message;

  UberOneBenefit(
      {required this.assetImage, required this.title, required this.message});
}

class Plan {
  final String period;
  final double bill;
  // final DateTime?

  const Plan({required this.period, required this.bill});
}
