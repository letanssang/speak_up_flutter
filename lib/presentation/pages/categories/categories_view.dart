import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/utilities/constant/category_icon_list.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ModalRoute.of(context)!.settings.arguments as List<Category>;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(AppLocalizations.of(context)!.categories,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
            )),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setHeight(8),
          crossAxisSpacing: ScreenUtil().setWidth(8),
        ),
        itemCount: categoryImageList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCategoryCard(index, ref, categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(int index, WidgetRef ref, Category category) {
    final language = ref.watch(appLanguageProvider);
    final darkTheme = ref.watch(themeProvider);
    return Card(
      elevation: 3,
      color: darkTheme ? Colors.grey[850] : Colors.white,
      surfaceTintColor: Colors.white,
      child: InkWell(
        onTap: () {
          ref
              .read(appNavigatorProvider)
              .navigateTo(AppRoutes.category, arguments: category);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            categoryImageList[index],
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              language == Language.english
                  ? category.name
                  : category.translation,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
