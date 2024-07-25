import 'package:carousel_slider/carousel_slider.dart';
import 'package:eats/presentation/style/strings_app.dart';
import 'package:eats/presentation/widget/filter_categories_widget.dart';
import 'package:eats/presentation/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import '../style/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xff93B884),
                        Color(0xff529536),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringsApp.local,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffB7B7B7),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Santarém, Pará',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.secondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: Image.asset(
                                'assets/img_perfil.png',
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SearchBarWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Expanded(
                  child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: StringsApp.listFilterCategories.length,
                            itemBuilder: (context, index) {
                              var category =
                                  StringsApp.listFilterCategories[index];
                              return FilterCategoriesWidget(
                                text: category,
                                colorBackground: AppTheme.secondaryColor,
                                fontWeight: FontWeight.normal,
                                textColor: Colors.black,
                              );
                            }),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child: CarouselSlider(
              items: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image.asset(
                    'assets/banner.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.2,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
