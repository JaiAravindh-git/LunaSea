import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrHealthCheckTile extends StatelessWidget {
    final RadarrHealthCheck healthCheck;

    RadarrHealthCheckTile({
        Key key,
        @required this.healthCheck,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return LunaExpandableListTile(
            title: healthCheck.message,
            collapsedSubtitle1: subtitle1(),
            collapsedSubtitle2: subtitle2(),
            expandedTableContent: expandedTable(),
            expandedHighlightedNodes: highlightedNodes(),
            onLongPress: healthCheck.wikiUrl.lunaOpenGenericLink,
        );
    }

    TextSpan subtitle1() {
        return TextSpan(text: healthCheck.source);
    }

    TextSpan subtitle2() {
        return TextSpan(
            text: healthCheck.type.readable,
            style: TextStyle(
                color: healthCheck.type.lunaColour,
                fontWeight: LunaUI.FONT_WEIGHT_BOLD,
                fontSize: LunaUI.FONT_SIZE_SUBTITLE,
            ),
        );
    }

    List<LunaHighlightedNode> highlightedNodes() {
        return [
            LunaHighlightedNode(
                text: healthCheck.type.readable,
                backgroundColor: healthCheck.type.lunaColour,
            ),
        ];
    }

    List<LunaTableContent> expandedTable() {
        return [
            LunaTableContent(title: 'Source', body: healthCheck.source),
        ];
    }
}