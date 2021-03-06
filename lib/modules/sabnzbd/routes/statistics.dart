import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/sabnzbd.dart';

class SABnzbdStatistics extends StatefulWidget {
    static const ROUTE_NAME = '/sabnzbd/statistics';
    
    @override
    State<SABnzbdStatistics> createState() => _State();
}

class _State extends State<SABnzbdStatistics> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _refreshKey = GlobalKey<RefreshIndicatorState>();
    Future<SABnzbdStatisticsData> _future;
    SABnzbdStatisticsData _data;

    @override
    void initState() {
        super.initState();
        _refresh();
    }

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Future<SABnzbdStatisticsData> _fetch() async => SABnzbdAPI.from(Database.currentProfileObject).getStatistics();

    Future<void> _refresh() async {
        if(mounted) setState(() {
            _future = _fetch();
        });
    }

    Widget get _appBar => LunaAppBar(title: 'Server Statistics');

    Widget get _body => LSRefreshIndicator(
        refreshKey: _refreshKey,
        onRefresh: _refresh,
        child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                    case ConnectionState.done: {
                        if(snapshot.hasError || snapshot.data == null) return LSErrorMessage(onTapHandler: () => _refresh());
                        _data = snapshot.data;
                        return _list;
                    }
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    default: return LSLoader();
                }
            },
        ),
    );

    Widget get _list => LSListView(
        children: <Widget>[
            ..._status,
            ..._freeSpace,
            ..._statistics,
        ],
    );

    List<Widget> get _status => [
        LSHeader(text: 'Status'),
        LSContainerRow(
            children: <Widget>[
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Uptime', centerText: true),
                        subtitle: LSSubtitle(text: _data.uptime, centerText: true),
                        reducedMargin: true,
                    ),
                ),
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Version', centerText: true),
                        subtitle: LSSubtitle(text: _data.version, centerText: true),
                        reducedMargin: true,
                    ),
                ),
            ],
        ),
    ];

    List<Widget> get _freeSpace => [
        LSHeader(text: 'Free Space'),
        LSContainerRow(
            children: <Widget>[
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Temporary', centerText: true),
                        subtitle: LSSubtitle(text: '${_data.tempFreespace.toString()} GB', centerText: true),
                        reducedMargin: true,
                    ),
                ),
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Final', centerText: true),
                        subtitle: LSSubtitle(text: '${_data.finalFreespace.toString()} GB', centerText: true),
                        reducedMargin: true,
                    ),
                ),
            ],
        ),
    ];

    List<Widget> get _statistics {
        List<Widget> _blocks = [..._statisticsBlock(
            'Total Statistics',
            _data.dailyUsage,
            _data.weeklyUsage,
            _data.monthlyUsage,
            _data.totalUsage,
        )];
        for(var server in _data.servers) _blocks.addAll(_statisticsBlock(
            server.name,
            server.dailyUsage,
            server.weeklyUsage,
            server.monthlyUsage,
            server.totalUsage,
        ));
        return _blocks;
    }

    List<Widget> _statisticsBlock(String title, int daily, int weekly, int monthly, int total) => [
        LSHeader(text: title),
        LSContainerRow(
            children: <Widget>[
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Daily', centerText: true),
                        subtitle: LSSubtitle(text: daily.lunaBytesToString(), centerText: true),
                        reducedMargin: true,
                    ),
                ),
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Weekly', centerText: true),
                        subtitle: LSSubtitle(text: weekly.lunaBytesToString(), centerText: true),
                        reducedMargin: true,
                    ),
                ),
            ],
        ),
        LSContainerRow(
            children: <Widget>[
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Monthly', centerText: true),
                        subtitle: LSSubtitle(text: monthly.lunaBytesToString(), centerText: true),
                        reducedMargin: true,
                    ),
                ),
                Expanded(
                    child: LSCardTile(
                        title: LSTitle(text: 'Total', centerText: true),
                        subtitle: LSSubtitle(text: total.lunaBytesToString(), centerText: true),
                        reducedMargin: true,
                    ),
                ),
            ],
        ),
    ];
}
