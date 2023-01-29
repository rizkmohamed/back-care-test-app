import 'package:flutter_app/app/models/customer_address.dart';

class BillingDetails {
  CustomerAddress? billingAddress;
  CustomerAddress? shippingAddress;
  bool? rememberDetails;

  BillingDetails();

  void initSession() {
    billingAddress = CustomerAddress();
    shippingAddress = CustomerAddress();
  }

  Map<String, String?> getShippingAddressStripe() => {
        "name": shippingAddress?.nameFull(),
        "line1": shippingAddress!.addressLine,
        "city": shippingAddress!.city,
        "postal_code": shippingAddress!.postalCode,
        "country": (shippingAddress?.customerCountry?.name ?? "")
      };

  fromWpMeta(Map<String, String> data) async {
    final Map<String, String> shippingDetailsWpMeta = <String, String>{},
        billingDetailsWpMeta = <String, String>{};

    shippingDetailsWpMeta.addEntries(data.entries
        .where((element) => element.key.startsWith("shipping_"))
        .map((shippingMeta) => MapEntry(
            shippingMeta.key.replaceAll("shipping_", ""), shippingMeta.value)));
    billingDetailsWpMeta.addEntries(data.entries
        .where((element) => element.key.startsWith("billing_"))
        .map((billingMeta) => MapEntry(
            billingMeta.key.replaceAll("billing_", ""), billingMeta.value)));

    CustomerAddress billingCustomerAddress = CustomerAddress();
    await billingCustomerAddress.fromWpMetaData(billingDetailsWpMeta);

    CustomerAddress shippingCustomerAddress = CustomerAddress();
    await shippingCustomerAddress.fromWpMetaData(shippingDetailsWpMeta);

    billingAddress = billingCustomerAddress;
    shippingAddress = shippingCustomerAddress;
  }
}
