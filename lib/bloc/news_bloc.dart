// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final NewsRepository _newsRepository = NewsRepository();
  List<ArticleModel> newsList = [];
  final _newsFetcher = PublishSubject<List<ArticleModel>>();

  Stream<List<ArticleModel>> get allNews => _newsFetcher.stream;

  fetchAllNews({@required String? country}) async {
    List<ArticleModel> albumList =
        await _newsRepository.fetchArticles(country: country);
    _newsFetcher.sink.add(albumList);
  }

  lauchNewsUrl(String newsUrl) {
    FlutterWebBrowser.openWebPage(
      url: newsUrl,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: Colors.deepPurple,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.amber,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.amber,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  dispose() {
    _newsFetcher.close();
  }
}

NewsBloc newsBloc = NewsBloc();

