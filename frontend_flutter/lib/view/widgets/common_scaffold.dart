import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold(
      {Key? key,
      this.backgroundColor,
      required this.body,
      this.resizeToAvoidBottomInset = true,
      this.appBar,
      this.horizontalPadding,
      this.verticalPadding,
      this.commonHorizontalPadding = true,
      this.commonVerticalPadding = true})
      : super(key: key);

  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  ///ByDefault [commonHorizontalPadding] is true and the value will be 16.0.
  ///To add manual horizontal padding use [horizontalPadding] by double value
  final bool commonHorizontalPadding;
  final double? horizontalPadding;

  ///ByDefault [commonVerticalPadding] is true and the value will be 8.0.
  ///To add manual horizontal padding use [verticalPadding] by double value
  final bool commonVerticalPadding;
  final double? verticalPadding;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding == null
                  ? commonHorizontalPadding
                      ? 16.0
                      : 0.0
                  : horizontalPadding!,
              vertical: verticalPadding == null
                  ? commonVerticalPadding
                      ? 8.0
                      : 0.0
                  : verticalPadding!),
          child: body,
        ),
      ),
    );
  }
}
