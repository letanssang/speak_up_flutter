import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/utilities/constant/category_icon_list.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ModalRoute.of(context)!.settings.arguments as List<Category>;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return buildCategoryCard(index, ref, categories[index]);
          },
        ),
      ),
    );
  }

  Widget buildCategoryCard(int index, WidgetRef ref, Category category) {
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
            images[index],
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              language == Language.english
                  ? category.name
                  : category.translation,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
