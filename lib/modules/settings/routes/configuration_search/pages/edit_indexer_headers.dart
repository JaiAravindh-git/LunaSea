import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsConfigurationSearchEditHeadersRouter extends LunaPageRouter {
    SettingsConfigurationSearchEditHeadersRouter() : super('/settings/configuration/search/edit/:indexerid/headers');

    @override
    Future<void> navigateTo(BuildContext context, { @required int indexerId }) async => LunaRouter.router.navigateTo(context, route(indexerId: indexerId));

    @override
    String route({ @required int indexerId }) => super.fullRoute.replaceFirst(':indexerid', indexerId?.toString() ?? -1);
    
    @override
    void defineRoute(FluroRouter router) => router.define(
        super.fullRoute,
        handler: Handler(handlerFunc: (context, params) {
            int indexerId = params['indexerid'] == null || params['indexerid'].length == 0 ? -1 : (int.tryParse(params['indexerid'][0]) ?? -1);
            return _SettingsConfigurationSearchEditHeadersRoute(indexerId: indexerId);
        }),
        transitionType: LunaRouter.transitionType,
    );
}


class _SettingsConfigurationSearchEditHeadersRoute extends StatefulWidget {
    final int indexerId;

    _SettingsConfigurationSearchEditHeadersRoute({
        Key key,
        @required this.indexerId,
    }) : super(key: key);

    @override
    State<_SettingsConfigurationSearchEditHeadersRoute> createState() => _State();
}

class _State extends State<_SettingsConfigurationSearchEditHeadersRoute> with LunaScrollControllerMixin {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    IndexerHiveObject _indexer;

    @override
    Widget build(BuildContext context) {
        if(widget.indexerId < 0) return LunaInvalidRoute(title: 'Custom Headers', message: 'Indexer Not Found');
        if(!Database.indexersBox.containsKey(widget.indexerId)) return LunaInvalidRoute(title: 'Custom Headers', message: 'Indexer Not Found');
        return Scaffold(
            key: _scaffoldKey,
            appBar: _appBar(),
            body: _body(),
        );
    }

    Widget _appBar() {
        return LunaAppBar(
            title: 'Custom Headers',
            scrollControllers: [scrollController],
        );
    }

    Widget _body() {
        return ValueListenableBuilder(
            valueListenable: Database.indexersBox.listenable(keys: [widget.indexerId]),
            builder: (context, box, __) {
                if(!Database.indexersBox.containsKey(widget.indexerId)) return Container();
                _indexer = Database.indexersBox.get(widget.indexerId);
                return LunaListView(
                    controller: scrollController,
                    children: [
                        if((_indexer.headers ?? {}).isEmpty) LunaMessage.inList(text: 'No Headers Added'),
                        ..._list(),
                        _addHeader(),
                    ],
                );
            }
        );
    }

    List<Widget> _list() {
        Map<String, dynamic> headers = (_indexer.headers ?? {}).cast<String, dynamic>();
        List<String> _sortedKeys = headers.keys.toList()..sort();
        return _sortedKeys.map<LunaListTile>((key) => _headerTile(key, headers[key])).toList();
    }

    LunaListTile _headerTile(String key, String value) {
        return LunaListTile(
            context: context,
            title: LunaText.title(text: key.toString()),
            subtitle: LunaText.subtitle(text: value.toString()),
            trailing: LunaIconButton(
                icon: Icons.delete,
                color: LunaColours.red,
                onPressed: () async => HeaderUtility().deleteHeader(context, headers: _indexer.headers, key: key, indexer: _indexer),
            ),
        );
    }

    Widget _addHeader() {
        return LunaButtonContainer(
            children: [
                LunaButton(
                    text: 'Add Header',
                    onTap: () async => HeaderUtility().addHeader(context, headers: _indexer.headers, indexer: _indexer),
                ),
            ],
        );
    }
}
