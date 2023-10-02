import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/utilities/constant/alphabet_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';

class CommonWordTypes extends ConsumerWidget {
  const CommonWordTypes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: alphabetList.length,
      itemBuilder: (context, index) {
        return AppListTile(
            onTap: () {
              ref
                  .read(appNavigatorProvider)
                  .navigateTo(AppRoutes.commonWordType, arguments: index);
            },
            index: index,
            title:
                '${AppLocalizations.of(context)?.wordStartWith} ${alphabetList[index]}');
      },
    );
  }
}
