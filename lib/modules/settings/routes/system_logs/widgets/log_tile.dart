import 'package:expandable/expandable.dart';
import 'package:f_logs/f_logs.dart' as FLog;
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class SettingsLogsDetailsLogTile extends StatelessWidget {
    final FLog.Log log;
    final ExpandableController _controller = ExpandableController();

    SettingsLogsDetailsLogTile({
        @required this.log,
    });

    @override
    Widget build(BuildContext context) => LSExpandable(
        controller: _controller,
        collapsed: _collapsed(context),
        expanded: _expanded(context),
    );

    Widget _collapsed(BuildContext context) => LSCardTile(
        title: LSTitle(text: log.text),
        subtitle: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: Constants.UI_FONT_SIZE_SUBTITLE,
                    color: Colors.white70,
                ),
                children: [
                    TextSpan(text: log.timestamp),
                    TextSpan(text: '\n'),
                    TextSpan(
                        style: TextStyle(
                            color: log.logLevel.lunaColour,
                            fontWeight: LunaUI.FONT_WEIGHT_BOLD,
                        ),
                        text: log.logLevel.lunaName,
                    )
                ],
            ),
        ),
        padContent: true,
        onTap: () => _controller.toggle(),

    );

    Widget _expanded(BuildContext context) => LSCard(
        child: InkWell(
            child: Row(
                children: [
                    Expanded(
                        child: Padding(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    LSTitle(text: log.text, softWrap: true, maxLines: 12),
                                    Padding(
                                        child: Wrap(
                                            direction: Axis.horizontal,
                                            runSpacing: 10.0,
                                            children: [
                                                LSTextHighlighted(
                                                    text: log.logLevel.lunaName,
                                                    bgColor: log.logLevel.lunaColour,
                                                ),
                                            ],
                                        ),
                                        padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
                                    ),
                                    Padding(
                                        child: RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: Constants.UI_FONT_SIZE_SUBTITLE,
                                                ),
                                                children: [
                                                    TextSpan(text: log.timestamp),
                                                    if(log?.className != null) TextSpan(text: '\n${log.className}'),
                                                    if(log?.methodName != null) TextSpan(text: '\n${log.methodName}'),
                                                ],
                                            ),
                                        ),
                                        padding: EdgeInsets.only(top: 6.0, bottom: (log?.exception != null && (log?.exception?.toLowerCase() ?? 'null') != 'null') ? 10.0 : 0.0),
                                    ),
                                    if(log?.exception != null && (log?.exception?.toLowerCase() ?? 'null') != 'null') Padding(
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                Expanded(
                                                    child: LSButtonSlim(
                                                        text: 'Exception',
                                                        backgroundColor: LunaColours.red,
                                                        onTap: () async => LunaDialogs().textPreview(context, 'Exception', log?.exception ?? 'Unavailable', alignLeft: true),
                                                        margin: EdgeInsets.only(right: 6.0),
                                                    ),
                                                ),
                                                Expanded(
                                                    child: LSButtonSlim(
                                                        text: 'Stack Trace',
                                                        backgroundColor: LunaColours.blue,
                                                        onTap: () async => LunaDialogs().textPreview(context, 'Stack Trace', log?.stacktrace ?? 'Unavailable', alignLeft: true),
                                                        margin: EdgeInsets.only(left: 6.0),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        padding: EdgeInsets.only(bottom: 2.0),
                                    ),
                                ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        ),
                    ),
                ],
            ),
            borderRadius: BorderRadius.circular(Constants.UI_BORDER_RADIUS),
            onTap: () => _controller.toggle(),
        ),
    );
}