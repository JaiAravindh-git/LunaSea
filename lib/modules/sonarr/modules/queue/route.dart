import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/sonarr.dart';

class SonarrQueueRouter {
    static const String ROUTE_NAME = '/sonarr/queue/list';

    static Future<void> navigateTo(BuildContext context) async => LunaRouter.router.navigateTo(
        context,
        route(),
    );

    static String route() => ROUTE_NAME;

    static void defineRoutes(FluroRouter router) {
        router.define(
            ROUTE_NAME,
            handler: Handler(handlerFunc: (context, params) => _SonarrQueueRoute()),
            transitionType: LunaRouter.transitionType,
        );
    }
}

class _SonarrQueueRoute extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<_SonarrQueueRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

    @override
    void initState() {
        super.initState();
        SchedulerBinding.instance.scheduleFrameCallback((_) => _refresh());
    }

    Future<void> _refresh() async {
        context.read<SonarrState>().resetQueue();
        await context.read<SonarrState>().queue;
    }

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LunaAppBar(title: 'Queue');

    Widget get _body => LSRefreshIndicator(
        refreshKey: _refreshKey,
        onRefresh: _refresh,
        child: FutureBuilder(
            future: context.watch<SonarrState>().queue,
            builder: (context, AsyncSnapshot<List<SonarrQueueRecord>> snapshot) {
                if(snapshot.hasError) {
                    if(snapshot.connectionState != ConnectionState.waiting) {
                        LunaLogger().error('Unable to fetch Sonarr queue', snapshot.error, StackTrace.current);
                    }
                    return LSErrorMessage(onTapHandler: () async => _refreshKey.currentState.show());
                }
                if(snapshot.hasData) return snapshot.data.length == 0
                    ? _emptyQueue
                    : _queue(snapshot.data);
                return LSLoader();
            },
        ),
    );

    Widget get _emptyQueue => LSGenericMessage(
        text: 'Empty Queue',
        buttonText: 'Refresh',
        showButton: true,
        onTapHandler: () async => _refreshKey.currentState.show(),
    );

    Widget _queue(List<SonarrQueueRecord> queue) => LSListView(
        children: List.generate(
            queue.length,
            (index) => SonarrQueueQueueTile(
                key: ObjectKey(queue[index].id),
                record: queue[index],
            ),
        ),
    );
}
