import 'package:flutter/material.dart';
import 'package:techworks/config.dart';
import 'package:techworks/localization/ru.dart';
import 'package:techworks/api.dart';
import 'package:techworks/model.dart';
import 'package:techworks/show.dart';

void main() => runApp(const TWApp());

class TWApp extends StatefulWidget {
  const TWApp({Key? key}) : super(key: key);

  @override
  _TWAppState createState() => _TWAppState();
}

class _TWAppState extends State<TWApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(microseconds: REFRESH_DURATION));
    setState(() {
      Api.fetchData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(APP_TITLE),
          actions: [
            IconButton(onPressed: refreshList, icon: Icon(Icons.settings)),
          ],
        ),
        body: RefreshIndicator(
          color: Colors.white,
          child: FutureBuilder<List<PostModel>>(
            future: Api.fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                final err = snapshot.error.toString();
                if (err == '403') {
                  return RefreshIndicator(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Text(MSG_NOT_AVAIL),
                        ),
                      ),
                      onRefresh: refreshList);
                } else if (err == '523') {
                  return RefreshIndicator(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Text(MSG_NO_INET),
                        ),
                      ),
                      onRefresh: refreshList);
                } else {
                  return RefreshIndicator(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Text(MSG_SERVER_ERR),
                        ),
                      ),
                      onRefresh: refreshList);
                }
              }
              if (snapshot.hasData) {
                final posts = snapshot.data;
                if (posts.length == 0) {
                  return RefreshIndicator(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Text(MSG_NODATA),
                        ),
                      ),
                      onRefresh: refreshList);
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(posts[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(posts[index].description),
                        leading: Icon(Icons.label),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          if (posts.length > 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Show(
                                        title: posts[index].title,
                                        postdata: posts[index].data)));
                          }
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)));
              }
            },
          ),
          onRefresh: refreshList,
        ),
      ),
    );
  }
}
