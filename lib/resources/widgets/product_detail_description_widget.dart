import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/woosignal_ui.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woosignal/models/response/products.dart';

class ProductDetailDescriptionWidget extends StatelessWidget {
  const ProductDetailDescriptionWidget({Key? key, required this.product})
      : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    if (product!.shortDescription!.isEmpty && product!.description!.isEmpty) {
      return SizedBox.shrink();
    }

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.003,
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                trans("Product Detail"),
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              if (product!.shortDescription!.isNotEmpty &&
                  product!.description!.isNotEmpty)
                MaterialButton(
                  child: Text(
                    trans("Full description"),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 14),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  height: 50,
                  minWidth: 60,
                  onPressed: () => _modalBottomSheetMenu(context),
                ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.003,
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: HtmlWidget(
              product!.shortDescription!.isNotEmpty
                  ? product!.shortDescription!
                  : product!.description!,
              renderMode: RenderMode.column, onTapUrl: (String url) async {
            await launchUrl(Uri.parse(url));
            return true;
          },
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  _modalBottomSheetMenu(BuildContext context) {
    wsModalBottom(
      context,
      title: trans("Description"),
      bodyWidget: SingleChildScrollView(
        child: HtmlWidget(product!.description!),
      ),
    );
  }
}
