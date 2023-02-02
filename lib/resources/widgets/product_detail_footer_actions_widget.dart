import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/widgets/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/products.dart';

class ProductDetailFooterActionsWidget extends StatelessWidget {
  const ProductDetailFooterActionsWidget(
      {Key? key,
      required this.product,
      required this.quantity,
      required this.onAddToCart,
      required this.onViewExternalProduct,
      required this.onAddQuantity,
      required this.onRemoveQuantity})
      : super(key: key);
  final Product? product;
  final Function onViewExternalProduct;
  final Function onAddToCart;
  final Function onAddQuantity;
  final Function onRemoveQuantity;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.003,
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: ThemeColor.get(context).background,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            spreadRadius: -17,
            offset: Offset(
              0,
              -10,
            ),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (product!.type != "external")
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  trans("Quantity"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.grey),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: ThemeColor.get(context).buttonBackground,
                      ),
                      onPressed: onRemoveQuantity as void Function()?,
                    ),
                    Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: ThemeColor.get(context).buttonBackground,
                      ),
                      onPressed: onAddQuantity as void Function()?,
                    ),
                  ],
                )
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Align(
                child: AutoSizeText(
                  formatStringCurrency(
                      total:
                          (parseWcPrice(product!.price) * quantity).toString()),
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.centerLeft,
              )),
              product!.type == "external"
                  ? Flexible(
                      child: PrimaryButton(
                        title: trans("Buy Product"),
                        action: onViewExternalProduct,
                      ),
                    )
                  : Flexible(
                      child: PrimaryButton(
                        title: trans("Add to cart"),
                        action: onAddToCart,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
