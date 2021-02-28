import 'package:central_music/helpers/storage_helper.dart';
import 'package:central_music/models/publicati_with_range.dart';
import 'package:central_music/pages/image_slider.dart';
import 'package:central_music/services/chat_list_service.dart';
import 'package:central_music/services/main_page_services.dart';
import 'package:central_music/services/publication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/sizes_helpers.dart';

class PublicationDetailsPage extends StatefulWidget {
  final PublicationWithRange gridItem;

  const PublicationDetailsPage({Key key, this.gridItem, BuildContext context})
      : super(key: key);

  @override
  _PublicationDetailsPage createState() => _PublicationDetailsPage();
}

class _PublicationDetailsPage extends State<PublicationDetailsPage> {
  List<String> userImgList = [];

  Color _favIconColor = Colors.black;
  String _isFavorite = "";

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  List<PublicationWithRange> favoriteList = new List();

  void getFavorites() {
    Services.getFavoritePublicationsById().then((value) {
      print("Favorite list length " + value.length.toString());
      favoriteList = value;
      print(favoriteList.isEmpty);

      if (!favoriteList.isEmpty) {
        for (PublicationWithRange p in favoriteList) {
          print(p.id);
          print(widget.gridItem.id);
          print(p.id == widget.gridItem.id);
          if (p.id == widget.gridItem.id) {
            print("a enviar true");
            setState(() {
              _favIconColor = Colors.amberAccent;
              print(_favIconColor);
              _isFavorite = "true";
            });
          }
        }
      } else {
        setState(() {
          _favIconColor = Colors.black;
          print(_favIconColor);
        });
        print(_isFavorite);
      }
    });
  }

  List<String> loadImagelist(int id, int max) {
    setState(() {
      for (int i = 0; i < max; i++) {
        userImgList.add("https://10.0.2.2:5001/images/Uploads/Posts/" +
            id.toString() +
            "/" +
            i.toString() +
            ".png");
      }
      print("max " + max.toString() + " USer list" + userImgList.toString());
    });
    return userImgList;
  }


  @override
  Widget build(BuildContext context) {

    List<String> postList = loadImagelist(widget.gridItem.id, widget.gridItem.imagePath);
    print("VALOR DE _favorite" + _isFavorite);

    //
    void _addRemoveFromFavorites(int id, String isFavorite) async {
      print(id);
      print("ISfavorite addRemoveF");
      print(isFavorite);
      if (_favIconColor == Colors.black) {
        await PublicationServices.addToFavorites(id).then((value) {
          callCostumToast("Adicionado aos favoritos");
          print("Value de add");
          print(value);
          setState(() {
            //  _isFavorite = "false";
            _favIconColor = Colors.amberAccent;
          });
        });
      } else if (_favIconColor == Colors.amberAccent) {
        await PublicationServices.removeFromFavorites(id).then((value) {
          callCostumToast("Removido dos favoritos");
          print("Value de remove");
          print(value);
          setState(() {
            _favIconColor = Colors.black;
            //  _isFavorite = "true";
          });
        });
      } else {
        callCostumToast("Sem operacoes possiveis");
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(top: 20),
              child: Text(
                widget.gridItem.tittle,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Stack(alignment: Alignment.center, children: <Widget>[
              SizedBox(
                // height: 400.0,
                // width: 600.0,
                child: ImageSliderDemo(postList), //imgList
              ),
            ]), //Adicionar botao de gosto aqui
            Container(
                // height: 300.0,
                child: Row(children: [
              Container(
                  width: displayWidth(context) * 0.3,
                  //alignment: Alignment.bottomLeft,

                  height: displayWidth(context) * 0.1,
                  margin: EdgeInsets.only(
                      top: 10, right: 10, left: displayWidth(context) * 0.05),
                  padding: EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.grey[350],
                  ),
                  child: Text(
                    "Initial Price: " +
                        widget.gridItem.initialPrice.toString() +
                        "€",
                    style: TextStyle(fontSize: 15),
                  )),
              Container(
                width: displayWidth(context) * 0.5,
                alignment: Alignment.bottomRight,
                child: IconButton(
                  iconSize: 40.0,
                  color: _favIconColor,
                  onPressed: () {
                    setState(() {
                      _addRemoveFromFavorites(widget.gridItem.id, "false");
                    });
                  },
                  icon: Icon(Icons.favorite),
                ),
              )
            ])),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: displayWidth(context) * 0.4,
                    height: displayWidth(context) * 0.1,
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 8.0, right: 8, top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.grey[350],
                    ),
                    child: Text(
                        "Category: " + widget.gridItem.category.toString())),
                Container(
                    width: displayWidth(context) * 0.9,
                    height: displayWidth(context) * 0.4,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(
                        left: 10.0, top: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.grey[350],
                    ),
                    child: Text("Description: ddsfgggggggggggggggggggggg"
                            "gggggggggggggggggggggggggggggggggggggggggggggggggggggg"
                            "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg" +
                        widget.gridItem.description)),
              ],
            ),
            GestureDetector(
              onTap: () {
                createChat(widget.gridItem.utilizadorId);
              },
              child: Container(
                width: displayWidth(context) * 0.15,
                height: displayWidth(context) * 0.15,
                margin: EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                 color: Colors.amber[400],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    'Chat!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Future<void> isFavoriteP(int id) async {
//   print("entrou aqui");
//
//   await PublicationServices.isFavorite(id).then((value) {
//     setState(() {
//       if(value == "true"){
//         print(value);
//         _favIconColor = Colors.black;
//       }else{
//         print(value);
//         _favIconColor = Colors.amberAccent;
//       }
//     });
//   });
// }

}

void createChat(int userId) async {
  final String token = await StorageHelper.readTokenID();
  print("TokenId: " + token + " userId:" + userId.toString());

  if (token != userId) {
    ChatListServices.createChat2(userId).then((value) {
      if (value == "Concluído!") {
        callCostumToast("Chat Criado com sucesso!");
      } else if (token == userId) {
        callCostumToast("Esta publicação é sua!");
      } else {
        callCostumToast("Chat ja existe!");
      }
    });
  }
}

void callCostumToast(String words) {
  Fluttertoast.showToast(
      msg: words,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.amberAccent[100],
      textColor: Colors.black,
      fontSize: 10.0);
}
