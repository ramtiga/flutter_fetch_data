import 'package:fetch_data/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/user.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    AsyncValue<List<User>> users = watch(userStateFuture);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Listing Users'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: users.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('${error.toString()}')),
          data: (value) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.refresh(userStateFuture);
              },
              child: ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var fullName = value[index].name.title +
                        " " +
                        value[index].name.first +
                        " " +
                        value[index].name.last;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(value[index].picture.large),
                                  radius: 24.0,
                                ),
                                SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fullName.toString(),
                                        style: TextStyle(fontSize: 17.0),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        value[index].email.toString(),
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
