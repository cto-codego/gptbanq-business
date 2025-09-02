part of 'converter_bloc.dart';

@immutable
class ConverterEvent {}

class ConvertCurrencyListEvent extends ConverterEvent {
  final String? buyCurrency;

  ConvertCurrencyListEvent({this.buyCurrency});
}

class CurrencyRateEvent extends ConverterEvent {
  final String? buyCurrency, sellCurrency;

  CurrencyRateEvent({this.buyCurrency, this.sellCurrency});
}

class CurrencyRateNoLoadingEvent extends ConverterEvent {
  final String? buyCurrency, sellCurrency;

  CurrencyRateNoLoadingEvent({this.buyCurrency, this.sellCurrency});
}

class CurrencyConvertConfirmEvent extends ConverterEvent {
  final String? buyCurrencyId, sellCurrencyId, amount;

  CurrencyConvertConfirmEvent(
      {this.buyCurrencyId, this.sellCurrencyId, this.amount});
}


