import 'package:flutter/material.dart';
import 'package:madspilds_app/data.dart';

class Tilfoej extends StatefulWidget {

  @override
  _TilfoejState createState() => _TilfoejState();
}

class _TilfoejState extends State<Tilfoej> {
  final navneController = TextEditingController();
  final datoController = TextEditingController();
  final antalController = TextEditingController();
  final kategoriController = TextEditingController();

  DateTime udloebsDato = DateTime.now();

  @override
  void dispose() {
    navneController.dispose();
    super.dispose();
  }

  Future<void> _vaelgDato(BuildContext context) async {
    DateTime dato = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days:1 )),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (dato != null) {
      setState(() {
        datoController.text = (dato.day.toString() + "/" + dato.month.toString() + "-" + dato.year.toString());
        udloebsDato = dato;
      });
    }
  }

  Future<void> _indsaet() async {
    DatabaseEjer db = DatabaseEjer.instans;

    MadType madType = MadType();
    madType.navn = navneController.text;
    madType.kategori = kategoriController.text;

    madType = await db.findEllerIndsaetMadType(madType);

    MadVare madVare = MadVare();
    madVare.type_id = madType.id;
    madVare.antal = int.parse(antalController.text); 
    madVare.udloebsdato = DateTime.tryParse(datoController.text);

    db.indsaetMadVare(madVare);

    print(await db.alleMadVarer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj vare"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: navneController,
                decoration: InputDecoration(
                  icon: Icon(Icons.fastfood),
                  hintText: "Navn",
                ),
              ),
              Container(height: 8.0),
              TextFormField(
                controller: kategoriController,
                decoration: InputDecoration(
                  icon: Icon(Icons.category),
                  hintText: "Kategori (valgfrit)",
                ),
              ),
              Container(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: antalController,
                decoration: InputDecoration(
                  icon: Icon(Icons.format_list_numbered),
                  hintText: "Antal"                  
                ),
              ),
              Container(height: 8.0),
              InkWell(
                onTap: () => _vaelgDato(context),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: datoController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range),
                      hintText: "Udløbsdato",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          _indsaet();
        },
      ),
    );
  }
}