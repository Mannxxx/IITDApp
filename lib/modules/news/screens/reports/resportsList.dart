import 'package:IITDAPP/modules/news/data/newsData.dart';
import 'package:IITDAPP/modules/news/screens/newsPage.dart';
import 'package:IITDAPP/modules/news/widgets/cards/imageOverlay/text/newsDate.dart';

import 'package:IITDAPP/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:IITDAPP/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';

class ReportsList extends StatelessWidget {
  final NewsModel news;
  final bool redirectPossible;
  const ReportsList(this.news, this.redirectPossible);
  @override
  Widget build(BuildContext context) {
    final reports = news.reports;
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeModel>(context).theme.SCAFFOLD_BACKGROUND,
      appBar: CustomAppBar(title: Text('Reports'), withMenu: false),
      body: Container(
        child: (reports.isEmpty)
            ? Center(
                child: Text(
                  'No Reports',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
                ),
              )
            : ListView.builder(
                itemCount: reports.length + 1,
                itemBuilder: (_, i) {
                  if (i == 0) {
                    if (!redirectPossible) {
                      return Container();
                    }
                    return ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewsPage(
                            imageTag: 't${news.id}',
                            item: news,
                            redirectPossible: false,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Provider.of<ThemeModel>(context)
                            .theme
                            .RAISED_BUTTON_BACKGROUND,
                      ),
                      child: Text(
                        'View News',
                        style: TextStyle(
                          color: Provider.of<ThemeModel>(context)
                              .theme
                              .RAISED_BUTTON_FOREGROUND,
                        ),
                      ),
                    );
                  }
                  return Card(
                    color: Provider.of<ThemeModel>(context).theme.cardColor,
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          NewsDate(
                            createdAt: reports[reports.length - i].reportedAt,
                            size: 13,
                            color: Provider.of<ThemeModel>(context)
                                .theme
                                .hintColor,
                          ),
                          const Divider(),
                          Text(
                            reports[reports.length - i].description,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
