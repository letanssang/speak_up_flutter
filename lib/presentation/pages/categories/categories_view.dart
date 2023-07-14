import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/utilities/constant/categories.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = ref.watch(themeProvider);

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
            return buildCategoryCard(index, isDarkTheme, ref);
          },
        ),
      ),
    );
  }

  Widget buildCategoryCard(int index, bool darkTheme, WidgetRef ref) {
    return Card(
      elevation: 5,
      color: darkTheme ? Colors.grey[850] : Colors.white,
      child: InkWell(
        onTap: () {
          ref
              .read(appNavigatorProvider)
              .navigateTo(AppRoutes.category, arguments: index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            images[index],
            Text(
              textAlign: TextAlign.center,
              categories[index].name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
