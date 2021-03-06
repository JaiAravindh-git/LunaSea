import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrAppBarGlobalSettingsAction extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return LunaIconButton(
            icon: Icons.more_vert,
            onPressed: () async {
                Tuple2<bool, RadarrGlobalSettingsType> values = await RadarrDialogs().globalSettings(context);
                if(values.item1) values.item2.execute(context);
            },
        );
    }
}
