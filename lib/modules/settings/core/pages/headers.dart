import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsHeaderRoute extends StatefulWidget {
    final LunaModule module;

    SettingsHeaderRoute({
        Key key,
        @required this.module,
    }) : super(key: key);

    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<SettingsHeaderRoute> with LunaScrollControllerMixin {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) {
        if(widget.module == null) return LunaInvalidRoute(
            title: 'Custom Headers',
            message: 'Unknown Module',
        );
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
            valueListenable: Database.profilesBox.listenable(),
            builder: (context, profile, _) => LunaListView(
                controller: scrollController,
                children: [
                    if((_headers() ?? {}).isEmpty) _noHeadersFound(),
                    ..._headerList(),
                    _addHeader(),
                ],
            ),
        );
    }

    Widget _noHeadersFound() => LunaMessage.inList(text: 'No Headers Added');

    List<LunaListTile> _headerList() {
        Map<String, dynamic> headers = (_headers() ?? {}).cast<String, dynamic>();
        List<String> _sortedKeys = headers.keys.toList()..sort();
        return _sortedKeys.map<LunaListTile>((key) => _headerTile(key, headers[key])).toList();
    }

    LunaListTile _headerTile(String key, String value) {
        return LunaListTile(
            context: context,
            title: LunaText.title(text: key),
            subtitle: LunaText.subtitle(text: value),
            trailing: LunaIconButton(
                icon: Icons.delete,
                color: LunaColours.red,
                onPressed: () async {
                    await HeaderUtility().deleteHeader(context, headers: _headers(), key: key);
                    _resetState();
                }
            ),
        );
    }

    Widget _addHeader() {
        return LunaButtonContainer(
            children: [
                LunaButton(
                    text: 'Add Header',
                    onTap: () async {
                        await HeaderUtility().addHeader(context, headers: _headers());
                        _resetState();
                    }
                ),
            ],
        );
    }

    Map<dynamic, dynamic> _headers() {
        switch(widget.module) {
            case LunaModule.DASHBOARD: throw Exception('Dashboard does not have a headers page');
            case LunaModule.LIDARR: return Database.currentProfileObject.lidarrHeaders;
            case LunaModule.RADARR: return Database.currentProfileObject.radarrHeaders;
            case LunaModule.SONARR: return Database.currentProfileObject.sonarrHeaders;
            case LunaModule.SABNZBD: return Database.currentProfileObject.sabnzbdHeaders;
            case LunaModule.NZBGET: return Database.currentProfileObject.nzbgetHeaders;
            case LunaModule.SEARCH: throw Exception('Search does not have a headers page');
            case LunaModule.SETTINGS: throw Exception('Settings does not have a headers page');
            case LunaModule.WAKE_ON_LAN: throw Exception('Wake on LAN does not have a headers page');
            case LunaModule.TAUTULLI: return Database.currentProfileObject.tautulliHeaders;
        }
        throw Exception('An unknown LunaModule was passed in.');
    }

    Future<void> _resetState() async {
        switch(widget.module) { 
            case LunaModule.DASHBOARD: throw Exception('Dashboard does not have a headers page');
            case LunaModule.LIDARR: return;
            case LunaModule.RADARR: return context.read<RadarrState>().reset();
            case LunaModule.SONARR: return context.read<SonarrState>().reset();
            case LunaModule.SABNZBD: return;
            case LunaModule.NZBGET: return;
            case LunaModule.SEARCH: throw Exception('Search does not have a headers page');
            case LunaModule.SETTINGS: throw Exception('Settings does not have a headers page');
            case LunaModule.WAKE_ON_LAN: throw Exception('Wake on LAN does not have a headers page');
            case LunaModule.TAUTULLI: return context.read<TautulliState>().reset();
        }
        throw Exception('An unknown LunaModule was passed in.');
    }
}
