import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/bloc/news_bloc.dart';

class ListViewScreen extends StatefulWidget {
  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  final _searchController = TextEditingController();
  List<ArticleModel> _filteredNewsList = [];

  @override
  void dispose() {
    newsBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? todo = ModalRoute.of(context)!.settings.arguments as String?;
    final String? _selectedCountry = todo;
    newsBloc.fetchAllNews(country: _selectedCountry);
  }

  void _filterNewsList() {
    String searchTerm = _searchController.text.toLowerCase();
    List<ArticleModel> filteredList = newsBloc.newsList
        .where((article) =>
            article.title!.toLowerCase().contains(searchTerm) ||
            article.description!.toLowerCase().contains(searchTerm))
        .toList();
    setState(() {
      _filteredNewsList = filteredList;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredNewsList = [];
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterNewsList(),
              decoration: InputDecoration(
                hintText: 'Search news',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: _filterNewsList,
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    final List<ArticleModel> newsList = _filteredNewsList.isNotEmpty
        ? _filteredNewsList
        : newsBloc.newsList;

    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (BuildContext context, int index) {
        ArticleModel article = newsList[index];

        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            onTap: () => newsBloc.lauchNewsUrl(article.url!),
            leading: article.urlToImage != null
                ? Image.network(
                    article.urlToImage!,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  )
                : Container(),
            title: Text(
              article.title!,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              article.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber, // Customize app bar color
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<List<ArticleModel>>(
              stream: newsBloc.allNews,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ArticleModel>> snapshot) {
                if (snapshot.hasData) {
                  newsBloc.newsList = snapshot.data!;
                  return _buildNewsList();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String? todo = ModalRoute.of(context)!.settings.arguments as String?;
    return MaterialApp(
      home: SearchPage(country: todo),
    );
  }
}

class SearchPage extends StatefulWidget {
  final String? country; // Declare the country variable

  const SearchPage({Key? key, this.country}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<ArticleModel> _filteredNewsList = [];

  void updateList(String value) {
    List<ArticleModel> filteredList = [];
    if (value.isNotEmpty) {
      filteredList = newsBloc.newsList
          .where((article) =>
              article.title!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filteredList = newsBloc.newsList;
    }
    setState(() {
      _filteredNewsList = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    newsBloc.fetchAllNews(country: widget.country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Customize app bar color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Search News",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: updateList,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200, // Customize text field background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Enter a keyword",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.grey, // Customize prefix icon color
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNewsList.length,
              itemBuilder: (context, index) {
                ArticleModel article = _filteredNewsList[index];

                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      newsBloc.lauchNewsUrl(article.url!);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(article.urlToImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black54,
                            child: Text(
                              article.title!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber, // Customize primary color
        hintColor: Colors.amber, // Customize accent color
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/listView': (context) => ListViewScreen(),
      },
    ));

