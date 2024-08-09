import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Login.dart';
import 'package:newsapp/Models/categories_new_model.dart';
import 'package:newsapp/Models/news_channel_headlines_model.dart';
import 'package:newsapp/View/categories_screen.dart';
import 'package:newsapp/View/news_detail_Screen.dart';
import 'package:newsapp/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn }

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final DateFormat format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';

  // for email and password login
  void signoutEmailPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Login()), // Navigate to Login screen
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      // Handle sign out error
      print('Sign out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()),
              );
            },
            icon: Image.asset('images/category_icon.png'),
          ),
        ),
        title: Text(
          "News",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                switch (item) {
                  case FilterList.bbcNews:
                    name = 'bbc-news';
                    break;
                  case FilterList.aryNews:
                    name = 'ary-news';
                    break;
                  case FilterList.independent:
                    name = 'independent';
                    break;
                  case FilterList.reuters:
                    name = 'reuters';
                    break;
                  case FilterList.cnn:
                    name = 'cnn';
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text('Ary News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.independent,
                child: Text('Independent'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.reuters,
                child: Text('Reuters'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text('CNN'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(children: [
        // Positioned(
        //   bottom: 20,
        //   right: 30,
        //  // child:
        //   // FloatingActionButton(
        //   //   onPressed: () => signout(context),
        //   //   child: Icon(Icons.login_rounded),
        //   // ),

        //   // FloatingActionButton(
        //   //   onPressed: () => signout(context),
        //   //   child: Icon(Icons.login_rounded),
        //   // )
        // ),
        ListView(
          children: [
            SizedBox(
              height: height * 0.55,
              width: width,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewChannelHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.black,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                        color: Colors.white,
                        // color: Color.fromARGB(255, 176, 251, 255),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   'images/error_image.jpg',
                              //   fit: BoxFit.cover,
                              //   width: width * 0.9,
                              //   height: height * 0.5,
                              // ),
                              SpinKitCircle(
                                size: 70,
                                color: Colors.blue,
                              ),
                              Text(
                                'Oops! 😥 No Data available at the moment',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ));

                    // Container(
                    //   color: Colors.blue,
                    //   //Text('Error 404 Not found ')
                    // ),
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles!.isEmpty) {
                    return const Center(
                      child: Text('No articles available.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final article = snapshot.data!.articles![index];
                        final dateTime =
                            DateTime.parse(article.publishedAt.toString());

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                  newImage: article.urlToImage.toString(),
                                  newsTitle: article.title.toString(),
                                  newsDate: article.publishedAt.toString(),
                                  author: article.author.toString(),
                                  description: article.description.toString(),
                                  content: article.content.toString(),
                                  source: article.source!.name.toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  //  color: const Color.fromARGB(255, 171, 210, 241),
                                  color: Colors.white30,
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * 0.02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: article.urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(child: spinKit2),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4,
                                  color: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.all(15),
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child: Text(
                                            article.title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                article.source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('General'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Container(
                      color: Color.fromARGB(255, 176, 251, 255),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(3.14 / 2),
                              child: SpinKitCircle(
                                size: 30,
                                color: Colors.lightBlue,
                              ),
                            ),
                            Text(
                              'Oops!😥 No Data available at the moment',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    )
                        // Text('Failed to load categories.'),

                        );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles!.isEmpty) {
                    return const Center(
                      child: Text('No articles available.'),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          final article = snapshot.data!.articles![index];
                          final dateTime =
                              DateTime.parse(article.publishedAt.toString());

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: article.urlToImage.toString(),
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Center(child: spinKit2),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: height * 0.18,
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                article.title.toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              // FloatingActionButton(
                                              //   onPressed: (() => signout(context)),
                                              //   child: Icon(Icons.login_rounded),
                                              //   backgroundColor: Colors
                                              //       .blueAccent, // Change the background color
                                              //   foregroundColor:
                                              //       Colors.white, // Change the icon color
                                              //   elevation: 10,
                                              //),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    article.source!.name
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    format.format(dateTime),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),

            // wrong one
            // FloatingActionButton(
            //   onPressed: (() => signout()),
            //   child: Icon(Icons.login_rounded),
            // )
          ],
        ),
        Positioned(
          bottom: 16,
          right: 36,
          child: FloatingActionButton(
            onPressed: () => signoutEmailPassword(context),
            child: Icon(Icons.login_rounded),
          ),
        )
        // Positioned(
        //   right: 16,
        //   bottom: 16,
        //   child: FloatingActionButton(
        //     onPressed: () => signout(context),
        //     child: Icon(Icons.login_rounded),
        //   ),
        // )
      ]),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
);
