enum PaymentType {
  cash,
  installment,
  cashAndInstallment,
}

PaymentType convertStringToPayment(String payment) {
  switch (payment) {
    case 'نقدی':
      return PaymentType.cash;
    case 'قسطی':
      return PaymentType.installment;
    case 'نقدی و قسطی':
      return PaymentType.cashAndInstallment;
    default:
      return PaymentType.cashAndInstallment;
  }
}

String convertPaymentToString(PaymentType type) {
  switch (type) {
    case PaymentType.cash:
      return 'نقدی';
    case PaymentType.installment:
      return 'قسطی';
    case PaymentType.cashAndInstallment:
      return 'نقدی و قسطی';
  }
}
