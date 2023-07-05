import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

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
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          children: [
            buildCategoryCard(
              AppImages.activeLifestyle(),
              'Active Lifestyle',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.art(),
              'Art',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.business(),
              'Business',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.community(),
              'Community',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.dining(),
              'Dining',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.entertainment(),
              'Entertainment',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.fashion(),
              'Fashion',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.festivities(),
              'Festivities',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.health(),
              'Health',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.literature(),
              'Literature',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.memorableEvents(),
              'Memorable Events',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.onlinePresence(),
              'Online Presence',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.personalDevelopment(),
              'Personal Development',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.relationship(),
              'Relationship',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.technology(),
              'Technology',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.travel(),
              'Travel',
              isDarkTheme,
            ),
            buildCategoryCard(
              AppImages.urbanLife(),
              'Urban Life',
              isDarkTheme,
            ),


          ],

        ),
      ),
    );
  }

  Card buildCategoryCard(Widget image, String title, bool darkTheme) {
    return Card(
      color: darkTheme ? Colors.grey[900] : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                Text(title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ],
            ),
          );
  }
}
