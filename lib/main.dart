import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(Chat());

final bd = Firestore.instance;

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Estado();
  }
}

class Estado extends StatefulWidget{
  @override
  State createState() => new ChatState();
}

class ChatState extends State<Estado> {

  final textController = TextEditingController();

  Widget buildItem(int index, DocumentSnapshot document){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 200.0,
        padding: EdgeInsets.fromLTRB(200.0, 0, 0.0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(10, 10, 10, .1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        right: 12, left: 12, top: 7, bottom: 5.0),
                    child: Text(document.data['mensaje'],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
                child: Icon(Icons.account_circle,
                  color: Colors.blue,
                  size: 40,)
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(milliseconds: 500));

    return new MaterialApp(

        debugShowCheckedModeBanner: false,

        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,

            leading: IconButton(
                icon: Icon(Icons.account_circle,
                  color: Colors.blue,
                  size: 40,)
            ),

            title: Column(
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 14),
                    alignment: Alignment(-1, 0),
                    child: Text("Felipe",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black)
                    )
                ),
                Container(
                  alignment: Alignment(-1, 0),
                  child: Text("Activo(a) hace 1 minuto",
                    style: TextStyle(
                        fontSize: 10,
                        color: Color.fromRGBO(10, 10, 10, .5)
                    )
                  ),
                ),
              ],
            ),

            actions: <Widget>[
              IconButton(icon: Icon(Icons.call, color: Colors.blueAccent,),),
              IconButton(icon: Icon(Icons.videocam, color: Colors.blueAccent,),),
              IconButton(icon: Icon(Icons.info, color: Colors.blueAccent,),)
            ],
          ),

        body: Container(
          child: StreamBuilder(
          stream: bd.collection("messenger").snapshots(),
          builder: (context, snapshot) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(20.0),
                  reverse: false,
                  itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                ),
              ),
              Divider(height: 5.0),
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor),
                  child:
                  buildTextComposer()
              ),
            ],
          );
        }
        ),
      )
    ));
  }

  Widget buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.apps, color: Colors.blueAccent,),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.camera_alt, color: Colors.blueAccent,),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.photo, color: Colors.blueAccent,),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.mic, color: Colors.blueAccent,),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color.fromRGBO(10, 10, 10, .05),),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                  TextField(
                    controller: textController,
                    onSubmitted: (String text) {
                      insertar(textController.text);
                      textController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Aa",
                    ),
                    cursorColor: Colors.blueAccent,
                  ),
                ),
              ),
            ),

            Icon(Icons.insert_emoticon, color: Colors.blueAccent,),

            Container( //new
              margin: EdgeInsets.symmetric(horizontal: 4.0), //new
              child: IconButton( //new
                icon: Icon(Icons.send),
                color: Colors.blueAccent,//new
                onPressed: () {
                  insertar(textController.text);
                  textController.clear();
                },
              ), //new
            ),
          ],
        ),
      ),
    );
  }
}

void insertar(String mensaje) async {
  await bd.collection("messenger").add({'mensaje': mensaje});
}
