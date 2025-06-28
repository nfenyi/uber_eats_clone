import 'enums.dart';

class ViewModelState {
  final bool isLoading;
  final Object? payload;
  final Result? result;

  ViewModelState({required this.isLoading, this.result, this.payload});
}
