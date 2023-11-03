import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_club_blog/carousel/carousel_slider.dart';
import 'package:flutter_club_blog/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const defaultFontFamily = "Avenir";
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff0d253c);
    const secondaryTextColor = Color(0xff2d4379);
    const primaryColor = Color(0xff376aed);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          primaryColor: primaryColor,
          useMaterial3: true,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 14,
                      fontFamily: defaultFontFamily,
                      fontWeight: FontWeight.w400)))),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 16,
              ),
              bodyMedium: TextStyle(
                  fontFamily: defaultFontFamily,
                  fontSize: 12,
                  color: secondaryTextColor),
              titleMedium: TextStyle(
                fontSize: 14,
                fontFamily: defaultFontFamily,
                color: secondaryTextColor,
              ),
              titleLarge: TextStyle(
                fontSize: 22,
                fontFamily: defaultFontFamily,
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ))),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme myTheme = Theme.of(context).textTheme;
    final stories = AppDatabase.stories;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 32, left: 32, top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hi, Jonathan!",
                      style: myTheme.titleMedium,
                    ),
                    Image.asset(
                      "assets/img/icons/notification.png",
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 24),
                child: Text(
                  "Explore today's",
                  style: myTheme.titleLarge,
                ),
              ),
              _storyList(context, stories, myTheme),
              const SizedBox(height: 16),
              const _CategoryList(),
              const SizedBox(height: 16),
              const _PostList()
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _storyList(
      BuildContext context, List<Story> stories, TextTheme myTheme) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Container(
            margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            colors: [
                              Color(0xff376aed),
                              Color(0xff49b0e2),
                              Color(0xff9cecfb),
                            ],
                          )),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(4),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/img/stories/${story.imageFileName}",
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        "assets/img/icons/${story.iconFileName}",
                        width: 24,
                        height: 24,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  story.name,
                  style: myTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categories = AppDatabase.categories;
    return CarouselSlider.builder(
        itemCount: categories.length,
        itemBuilder: (context, index, realIndex) {
          return _CategoryItem(
            left: realIndex == 0 ? 32.0 : 8.0,
            right: realIndex == categories.length - 1 ? 32.0 : 8.0,
            category: categories[realIndex],
          );
        },
        options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            viewportFraction: 0.8,
            aspectRatio: 1.2,
            initialPage: 0,
            disableCenter: true,
            autoPlay: false,
            enableInfiniteScroll: false,
            scrollPhysics: const BouncingScrollPhysics(),
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height));
  }
}

class _CategoryItem extends StatelessWidget {
  final Category category;
  final double left;
  final double right;
  const _CategoryItem({
    super.key,
    required this.category,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, 0, right, 0),
      child: Stack(
        children: [
          Positioned.fill(
              top: 100,
              bottom: 24,
              left: 65,
              right: 65,
              child: Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(blurRadius: 20, color: Color(0xaa0d253c))
                ]),
              )),
          Positioned.fill(
            child: Container(
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Color(0xff0d253c),
                      Colors.transparent,
                    ],
                  )),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  "assets/img/posts/large/${category.imageFileName}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 32,
            child: Text(
              category.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .apply(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = AppDatabase.posts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Latest News",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "More",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
