import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/cached_image_widget.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/products.dart';

import '../../bootstrap/app_helper.dart';

class ProductDetailImageSwiperWidget extends StatelessWidget {
  const ProductDetailImageSwiperWidget({
    Key? key,
    required this.product,
    required this.onTapImage,
    this.favbutton,
    this.sharebutton,
  }) : super(key: key);

  final Product? product;
  final void Function(int i) onTapImage;
  final Widget? favbutton;
  final Widget? sharebutton;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.40,
      child: SizedBox(
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) =>
                  CachedImageWidget(
                image: product!.images.isNotEmpty
                    ? product!.images[index].src
                    : getEnv("PRODUCT_PLACEHOLDER_IMAGE"),
              ),
              itemCount: product!.images.isEmpty ? 1 : product!.images.length,
              viewportFraction: 0.85,
              scale: 0.9,
              onTap: onTapImage,
            ),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: MediaQuery.of(context).size.height * 0.05,
              end: MediaQuery.of(context).size.width * 0.05,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (AppHelper.instance.appConfig!.wishlistEnabled == true)
                    Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: favbutton),
                  SizedBox(),
                  Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: sharebutton)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
