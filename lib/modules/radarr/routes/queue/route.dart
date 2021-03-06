import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class RadarrQueueRouter extends LunaPageRouter {
    RadarrQueueRouter() : super('/radarr/queue');

    @override
    void defineRoute(FluroRouter router) => super.noParameterRouteDefinition(router, _RadarrQueueRoute());
}

class _RadarrQueueRoute extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<_RadarrQueueRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: _appBar(),
            body: LunaMessage.goBack(context: context, text: 'Coming Soon'),
        );
    }

    Widget _appBar() {
        return LunaAppBar(
            title: 'Queue',
        );
    }
}
