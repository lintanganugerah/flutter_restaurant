import 'package:flutter/material.dart';
import 'package:restaurant_flutter/widgets/card_menu.dart';
import 'package:restaurant_flutter/widgets/title_medium.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final listCategories = List.generate(3, (index) => index + 1);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    "https://placehold.co/600x200/png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TitleMedium(text: "Title Restaurant"),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Location",
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listCategories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: Text(
                                      "Category ${listCategories[index]}",
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    TitleMedium(text: "Deskripsi", fontWeight: FontWeight.w300),
                    Text(
                      "Deskripsi disini",
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 24),
                    TitleMedium(text: "Menu", fontWeight: FontWeight.w300),
                    CardMenu(data: listCategories),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
