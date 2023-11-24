import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool isLoading = false;
  List<String> titles = [];
  List<String> image = [];
  List<String> news = [];
  getNews() async {
    setState(() {
      isLoading = true;
    });
    final dio = Dio();
    final response = await dio.get(
        "https://gnews.io/api/v4/top-headlines?category=general&lang=en&country=us&max=10&apikey=dfaad98489b0a14c2b63d8f1f2ec162c");
    //print(responce.data["articles"][0]["title"]);
    for (int i = 0; i < response.data["articles"].length; i++) {
      //print(response.data["articles"][i]["title"]);
      titles.add(response.data["articles"][i]["title"]);
      image.add(response.data["articles"][i]["image"]);
      news.add(response.data["articles"][i]["description"]);
    }
    setState(() {
      isLoading = false;
    });
  }

  List<Color> col = [
    Colors.purple.shade900,
    Colors.purple,
    Colors.blue,
    Colors.blue.shade900
  ];
  @override
  void initState() {
    getNews();
    super.initState();
  }

  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: col,
        ),
      ),
      height: 45,
      width: MediaQuery.of(context).size.width,
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : PageView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (
          context,
          int index,
          ) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network(image[index % image.length])),
            Padding(
              padding:
              const EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Text(
                titles[index % titles.length],
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Text(
                news[index % news.length],
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        );
      },
    ),
  );
}
