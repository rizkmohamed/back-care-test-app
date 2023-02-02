import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/products.dart';

class ProductDetailHeaderWidget extends StatelessWidget {
  const ProductDetailHeaderWidget({Key? key, required this.product})
      : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.003,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            product!.name!,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            // textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      formatStringCurrency(total: product!.price),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                      // textAlign: TextAlign.right,
                    ),
                    if (product!.onSale == true && product!.type != "variable")
                      Text(
                        formatStringCurrency(total: product!.regularPrice),
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    RatingBarIndicator(
                      rating: double.parse(product!.averageRating!),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                    Text(
                      (product!.stockStatus == "outofstock"
                          ? trans("Out of stock")
                          : trans("In Stock")),
                      style: (product!.stockStatus == "outofstock"
                          ? Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              )
                          : Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                  ],
                ),
              ),
              // Text(
              //   formatStringCurrency(total: product!.price),
              //   style: Theme.of(context).textTheme.headline4!.copyWith(
              //         fontSize: 20,
              //       ),
              //   textAlign: TextAlign.right,
              // ),
              // if (product!.onSale == true && product!.type != "variable")
              //   Text(
              //     formatStringCurrency(total: product!.regularPrice),
              //     style: TextStyle(
              //       color: Colors.grey,
              //       decoration: TextDecoration.lineThrough,
              //     ),
              //   )
            ],
          )
        ],
      ),
    );
  }
}
