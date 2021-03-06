import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';

class LunaState {
    LunaState._();

    /// Key for the [NavigatorState] to globally access context and other usages.
    static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    
    /// Calls `.reset()` on all states which extend [LunaModuleState].
    static void reset(BuildContext context) {
        // General
        Provider.of<DashboardState>(context, listen: false)?.reset();
        Provider.of<SearchState>(context, listen: false)?.reset();
        Provider.of<SettingsState>(context, listen: false)?.reset();
        // Automation
        Provider.of<LidarrState>(context, listen: false)?.reset();
        Provider.of<RadarrState>(context, listen: false)?.reset();
        Provider.of<SonarrState>(context, listen: false)?.reset();
        // Clients
        Provider.of<NZBGetState>(context, listen: false)?.reset();
        Provider.of<SABnzbdState>(context, listen: false)?.reset();
        // Monitoring
        Provider.of<TautulliState>(context, listen: false)?.reset();
    }
    
    /// Returns a [MultiProvider] with the provided child.
    /// 
    /// The [MultiProvider] has a [ChangeNotifierProvider] provider added for each module global state object.
    static MultiProvider providers({ @required Widget child }) => MultiProvider(
        providers: [
            // General
            ChangeNotifierProvider(create: (_) => DashboardState()),
            ChangeNotifierProvider(create: (_) => SearchState()),
            ChangeNotifierProvider(create: (_) => SettingsState()),
            // Automation
            ChangeNotifierProvider(create: (_) => SonarrState()),
            ChangeNotifierProvider(create: (_) => LidarrState()),
            ChangeNotifierProvider(create: (_) => RadarrState()),
            // Clients
            ChangeNotifierProvider(create: (_) => NZBGetState()),
            ChangeNotifierProvider(create: (_) => SABnzbdState()),
            // Monitoring
            ChangeNotifierProvider(create: (_) => TautulliState()),
        ],
        child: child,
    );
}

