import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  const CardMenu({super.key, required this.data});

  final List<int> data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        "https://placehold.co/600x400/png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        //Tinggi gradient sesuaikan tinggi card
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Menu ${index + 1}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Rp 25.000",
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
