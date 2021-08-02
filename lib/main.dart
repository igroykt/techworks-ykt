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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text(APP_TITLE)),
        body: Container(
          child: FutureBuilder<List<PostModel>>(
            future: Api.fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                final err = snapshot.error.toString();
                if (err == "HttpException: 403") {
                  return Center(child: Text(MSG_NOT_AVAIL));
                } else {
                  return Center(child: Text(MSG_SERVER_ERR));
                }
              }
              if (snapshot.hasData) {
                final posts = snapshot.data;
                if (posts.length == 0) {
                  return Center(child: Text(MSG_NODATA));
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
        ),
      ),
    );
  }
}
