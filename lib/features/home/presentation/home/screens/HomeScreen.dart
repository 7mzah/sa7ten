import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int carouselItems = 5;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  final List<String> _carouselImages = List.generate(
    carouselItems,
        (index) => 'images/food.png',
  );

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images after dependencies are available
    for (var imagePath in _carouselImages) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              onStretchTrigger: _refreshData,
              backgroundColor: Colors.white,
              elevation: 0,
              expandedHeight: MediaQuery.of(context).size.height * 0.34,
              title: _buildAppBarTitle(),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    _buildCarouselSlider(),
                    _buildSearchBar(),
                    _buildCarouselIndicators(),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(20, (i) => ListTile(title: Text("Item $i"))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            radius: 17,
            child: Icon(Icons.location_on),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deliver to",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  "Select your location",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider.builder(
      itemCount: _carouselImages.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(_carouselImages[index]),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.4,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.97,
        onPageChanged: (index, reason) {
          _currentPageNotifier.value = index;
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 120,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Search for restaurants, dishes...",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselIndicators() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPageNotifier,
        builder: (context, currentPage, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              carouselItems,
                  (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
