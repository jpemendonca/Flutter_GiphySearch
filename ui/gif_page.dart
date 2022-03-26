import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  const GifPage({Key? key, required this.gifData}) : super(key: key);
  final Map gifData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData['title']),
        actions: [
          IconButton(
              onPressed: () {
                Share.share(
                    '''Olha só esse gif que estou compartilhando com você!! 
                  
                  ${gifData['images']['fixed_height']['url']}''');
              },
              tooltip: 'Compartilhar',
              icon: const Icon(Icons.share))
        ],
      ),
      body: Center(
        child: Image.network(gifData['images']['fixed_height']['url']),
      ),
    );
  }
}
