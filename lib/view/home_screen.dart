import 'package:flutter/material.dart';
import 'package:restaurant_flutter/view/detail_screen.dart';
import 'package:restaurant_flutter/widgets/title_medium.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final listItems = List.generate(3, (index) => index + 1);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text("Restaurant", style: textTheme.titleLarge),
              Text("Recommended For You", style: textTheme.titleMedium),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailScreen();
                              },
                            ),
                          ),
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "https://placehold.co/600x400/png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox.square(dimension: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleMedium(text: "Restaurant"),
                                  const SizedBox(height: 8),
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
                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "A",
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
