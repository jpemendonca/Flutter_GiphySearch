// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';
import 'package:gif_app/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

var name = 'joao';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int offset = 0;

  Future<Map> _getGifs() async {
    //Essa função assincrona será chamada no parametro future no widget FutureBuilder
    // Para acessar o retorno dela utilizamos o snapshot.data
    // Agradecimento: https://www.macoratti.net/19/08/flut_futbld1.htm
    http.Response response;

    if (_search == null || _search == '') {
      var url = Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=hV2uufhZV2mmUf2s6F7UrwQ8HeQOQMRR&limit=24&rating=r');
      response = await http.get(url);
    } else {
      // var url = Uri.parse(
      //     'https://api.giphy.com/v1/gifs/search?api_key=yODzpt5PclV0FuRgrjWqmx48sBPQOaVY&q=$_search&limit=20&offset=$offset&rating=r&lang=pt');
      var url = Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=hV2uufhZV2mmUf2s6F7UrwQ8HeQOQMRR&q=$_search&limit=23&offset=$offset&rating=r&lang=pt');
      response = await http.get(url);
    }

    return json.decode(response.body);
  }

  // O metodo initState é chamado uma unica vez, assim que o app se inicia
  @override
  void initState() {
    super.initState();

    //_getGifs().then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network('https://i.imgur.com/G2gqneQ.gif'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              autofocus: false,
              maxLength: 20,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                counterText: '',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIconColor: Colors.white,
                labelText: 'Pesquisar gifs',
              ),
              style: TextStyle(color: Colors.white),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  offset = 0;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return createGifTable(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  //(snapshot.data! as Map<String, dynamic>)['data'].length

  // Se estivermos procurando alguma coisa, retorna um numero par de items
  // sem espaço no final
  // Se não estivermos retorna um espaço no final
  int getCount(data) {
    // Se eu nao estiver pesquisando o grid vai ter 24 elementos, que é o tamanho
    // maximo que a api para trending permite
    if (_search == null || _search == '') {
      return data.length;
    } else {
      // Se eu estiver pesquisando o grid vai ter 23 elementos (gifs) + 1, que
      // no caso é o container com carregar mais
      // Lembrando que a api de pesquisa permite no maximo 23 items por pagina
      return (data.length + 1);
    }
  }

  Widget createGifTable(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: getCount((snapshot.data! as Map<String, dynamic>)['data']),
      itemBuilder: (context, index) {
        // Se eu não estiver pesquisando (pag inicial) OU o index (contador da funcao)
        // for menor que o tamanho do map, vai carregar um container com o gif
        // O tamanho do map pode ser 24 (para trending) ou 23 para pesquisa
        if (_search == null ||
            index < (snapshot.data! as Map<String, dynamic>)['data'].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: (snapshot.data! as Map<String, dynamic>)['data'][index]
                  ['images']['fixed_height']['url'],
              height: 300,
              fit: BoxFit.cover,
            ),
            onLongPress: () {
              Share.share(
                  '''Olha só esse gif que estou compartilhando com você!! 
                  
                  ${(snapshot.data! as Map<String, dynamic>)['data'][index]['images']['fixed_height']['url']}}''');
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(
                      gifData: (snapshot.data! as Map<String, dynamic>)['data']
                          [index]),
                ),
              );
            },
          );
          ;
          //
        } else {
          // Nesse caso vao ser exibidos 24 elementos, sendo 23 gifs (maximo) e
          // um container com carregar mais

          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    'Carregar Mais',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  offset += 23;
                });
              },
            ),
          );
        }
      },
    );
  }
}
