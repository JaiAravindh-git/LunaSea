import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';
import 'package:package_info/package_info.dart';

class SettingsSystemRouter extends LunaPageRouter {
    SettingsSystemRouter() : super('/settings/system');

    @override
    void defineRoute(FluroRouter router) => super.noParameterRouteDefinition(router, _SettingsSystemRoute());
}

class _SettingsSystemRoute extends StatefulWidget {
    @override
    State<_SettingsSystemRoute> createState() => _State();
}

class _State extends State<_SettingsSystemRoute> with LunaScrollControllerMixin {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            appBar: _appBar(),
            body: _body(),
        );
    }

    Widget _appBar() {
        return LunaAppBar(
            title: 'System',
            scrollControllers: [scrollController],
        );
    }

    Widget _body() {
        return LunaListView(
            controller: scrollController,
            children: <Widget>[
                _versionInformation(),
                _logs(),
                LunaDivider(),
                SettingsSystemBackupRestoreBackupTile(),
                SettingsSystemBackupRestoreRestoreTile(),
                LunaDivider(),
                _enableSentry(),
                _clearConfiguration(),
            ],
        );
    }

    Widget _versionInformation() {
        return FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) => LunaListTile(
                context: context,
                title: LunaText.title(
                    text: snapshot.hasData
                        ? 'Version: ${snapshot.data.version} (${snapshot.data.buildNumber})'
                        : 'Version: Loading...',
                ),
                subtitle: LunaText.subtitle(text: 'View Recent Changes'),
                trailing: LunaIconButton(icon: Icons.system_update),
                onTap: LunaChangelog().showChangelog,
            ),
        );
    }

    Widget _logs() {
        return LunaListTile(
            context: context,
            title: LunaText.title(text: 'Logs'),
            subtitle: LunaText.subtitle(text: 'View, Export, & Clear Logs'),
            trailing: LunaIconButton(icon: Icons.developer_mode),
            onTap: () async => SettingsSystemLogsRouter().navigateTo(context),
        );
    }
    
    Widget _enableSentry() {
        return LunaDatabaseValue.ENABLED_SENTRY.listen(
            builder: (context, box, _) => LunaListTile(
                context: context,
                title: LunaText.title(text: 'Sentry'),
                subtitle: LunaText.subtitle(text: 'Crash and Error Tracking'),
                trailing: LunaSwitch(
                    value: LunaDatabaseValue.ENABLED_SENTRY.data,
                    onChanged: (value) async {
                        bool result = await SettingsDialogs().disableSentryWarning(context);
                        if(result) LunaDatabaseValue.ENABLED_SENTRY.put(value);
                    }
                ),
            ),
        );
    }

    Widget _clearConfiguration() {
        return LunaListTile(
            context: context,
            title: LunaText.title(text: 'Clear Configuration'),
            subtitle: LunaText.subtitle(text: 'Clean Slate'),
            trailing: LunaIconButton(icon: Icons.delete_sweep),
            onTap: () async {
                bool result = await SettingsDialogs().clearConfiguration(context);
                if(result) {
                    Database().setDefaults(clearAlerts: true);
                    LunaFirebaseAuth().signOut();
                    LunaState.reset(context);
                    showLunaSuccessSnackBar(
                        context: context,
                        title: 'Configuration Cleared',
                        message: 'Your configuration has been cleared',
                    );
                }
            },
        );
    }
}
