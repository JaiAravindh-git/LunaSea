import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrAppBarMovieSettingsAction extends StatelessWidget {
    final int movieId;

    RadarrAppBarMovieSettingsAction({
        Key key,
        @required this.movieId,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Consumer<RadarrState>(
            builder: (context, state, _) => FutureBuilder(
                future: state.movies,
                builder: (context, AsyncSnapshot<List<RadarrMovie>> snapshot) {
                    if(snapshot.hasError) return Container();
                    if(snapshot.hasData) {
                        RadarrMovie movie = snapshot.data.firstWhere((element) => element.id == movieId, orElse: () => null);
                        if(movie != null) return LunaIconButton(
                            icon: Icons.edit,
                            onPressed: () async {
                                Tuple2<bool, RadarrMovieSettingsType> values = await RadarrDialogs().movieSettings(context, movie);
                                if(values.item1) values.item2.execute(context, movie);
                            },
                        );
                    }       
                    return Container();
                },
            ),
        );
    }
}
