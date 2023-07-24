import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';

class LessonsView extends ConsumerStatefulWidget {
  const LessonsView({super.key});

  @override
  ConsumerState<LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends ConsumerState<LessonsView> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Featured Lessons'),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                  elevation: 5,
                  color: isDarkTheme ? Colors.grey[850] : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/temp_topic.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lesson name',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            );
          }),
    );
  }
}
