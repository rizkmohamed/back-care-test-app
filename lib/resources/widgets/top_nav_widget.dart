

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TopNavWidget extends StatelessWidget {
  const TopNavWidget({Key? key, this.onPressBrowseCategories})
      : super(key: key);
  final Function()? onPressBrowseCategories;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "${(trans("Shop").capitalize())} / ",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              AutoSizeText(
                trans("Newest"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ],
          ),
          Flexible(
            child: MaterialButton(
              minWidth: 100,
              height: 60,
              child: AutoSizeText(
                trans("Browse categories"),
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
              onPressed: onPressBrowseCategories,
            ),
          )
        ],
      );
}
