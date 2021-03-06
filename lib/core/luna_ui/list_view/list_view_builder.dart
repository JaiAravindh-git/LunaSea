import 'package:flutter/material.dart';

class LunaListViewBuilder extends StatelessWidget {
    final int itemCount;
    final Widget Function(BuildContext, int) itemBuilder;
    final EdgeInsetsGeometry padding;
    final ScrollPhysics physics;
    final ScrollController controller;

    LunaListViewBuilder({
        Key key,
        @required this.itemCount,
        @required this.itemBuilder,
        @required this.controller,
        this.padding,
        this.physics = const AlwaysScrollableScrollPhysics(),
    }) : super(key: key) {
        assert(itemCount != null);
        assert(itemBuilder != null);
    }

    @override
    Widget build(BuildContext context) {
        return NotificationListener<ScrollStartNotification>(
            onNotification: (notification) {
                if(notification.dragDetails != null) FocusManager.instance.primaryFocus?.unfocus();
                return null;
            },
            child: Scrollbar(
                controller: controller,
                child: ListView.builder(
                    controller: controller,
                    padding: padding != null ? padding : EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0+(MediaQuery.of(context).padding.bottom),
                    ),
                    physics: physics,
                    itemCount: itemCount,
                    itemBuilder: itemBuilder,
                ),
            ),
        );
    }
}
