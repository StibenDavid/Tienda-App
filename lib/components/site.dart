import 'package:flutter/material.dart';

class SiteList extends StatelessWidget {
  final List<Map<String, dynamic>> sites;
  final Function(BuildContext, String) onDelete;

  const SiteList({Key? key, required this.sites, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Ajusta el tamaño como necesites
      child: ListView.builder(
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final site = sites[index];
          return Dismissible(
            key: Key(site['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              onDelete(context, site['id']);
            },
            child: Card(
              child: ListTile(
                title: Text('Site Id: ${site['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${site['date']}'),
                    Text('Name: ${site['name']}'),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/editSite',
                    arguments: {
                      "siteId": site['id'] ?? '',
                      "date": site['date'] ?? '',
                      "name": site['name'] ?? '',
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
