import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliActivityDetailsTerminateSession extends StatelessWidget {
    final TautulliSession session;

    TautulliActivityDetailsTerminateSession({
        Key key,
        @required this.session,
    }): super(key: key);

    @override
    Widget build(BuildContext context) => LSButton(
        text: 'Terminate Session',
        backgroundColor: LunaColours.red,
        onTap: () async => _onPressed(context),
    );

    Future<void> _onPressed(BuildContext context) async {
        List _values = await TautulliDialogs.terminateSession(context);
        if(_values[0]) {
            context.read<TautulliState>().api.activity.terminateSession(
                sessionId: session.sessionId,
                message: _values[1] != null && (_values[1] as String).isNotEmpty ? _values[1] : null,
            )
            .then((_) {
                LSSnackBar(
                    context: context,
                    title: 'Terminated Session',
                    message: '${session.friendlyName}\t${Constants.TEXT_EMDASH}\t${session.title}',
                );
                Navigator.of(context).pop();
            })
            .catchError((error, trace) {
                LunaLogger().error('Unable to terminate session: ${session.sessionId}', error, trace);
                LSSnackBar(
                    context: context,
                    title: 'Failed to Terminate Session',
                    type: SNACKBAR_TYPE.failure,
                );
            });
        }
    }
}
