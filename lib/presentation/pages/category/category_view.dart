import 'package:flutter/material.dart';
import 'package:speak_up/domain/entities/category/category.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: category.topicIDs!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(category.topicIDs![index].toString()),
              subtitle: Text(category.topicIDs![index].toString()),
            );
          },
        ),
      ),
    );
  }
}
