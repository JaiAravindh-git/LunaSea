import 'package:intl/intl.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/sonarr.dart';

extension SonarrCalendarExtension on SonarrCalendar {
    String get lunaAirTime {
        if(this.airDateUtc != null) return LunaDatabaseValue.USE_24_HOUR_TIME.data
            ? DateFormat.Hm().format(this.airDateUtc.toLocal())
            : DateFormat('hh:mm a').format(this.airDateUtc.toLocal());
        return Constants.TEXT_EMDASH;
    }

    bool get lunaHasAired {
        if(this.airDateUtc != null) return DateTime.now().isAfter(this.airDateUtc.toLocal());
        return false;
    }
}
