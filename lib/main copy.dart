import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // HEX F40000 "Changer les couleurs de l’application pour que la couleur principale soit rouge (#F40000) et le texte soit blanc"
      //pas sur si la question demande que le fond d'écran doit être rouge ou pas
      // hex n'est pas supporté par défaut dans flutter, il faut créer une extension (voir plus bas dans le code)
      //Source https://stackoverflow.com/questions/70548623/change-primary-color-with-hex-color-in-flutter
      theme: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: HexColor('#F40000'),
            ),
      ),
      //// autre façon de faire
      //  theme: ThemeData(
      //   primarySwatch: Colors.red,
      //   hintColor: Colors.red,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.red,
      //       foregroundColor: Colors.white,
      //     ),
      //   ),
      // ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création d\'utilisateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('Utilisateur');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              print('Paramètres');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Nom de l\'application'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                print('Accueil');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Quitter'),
              onTap: () {
                print('quitté');
                Navigator.pop(context);
                //this tap closes the app
                //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        ),
      ),
      body: const Formulaire(),
    );
  }
}

class Formulaire extends StatefulWidget {
  const Formulaire({super.key});

  @override
  _MonFormulaireState createState() => _MonFormulaireState();
}

class _MonFormulaireState extends State<Formulaire> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _sexeController = TextEditingController();
  late String _sexeController;
  bool _acceptTerms = false;
  late Utilisateur _utilisateur; // late = pas de valeur par défaut

  ////ancienne fonction ne marche pas
  // String? _validateEmail(String? value) {
  //   String test = value ?? "";
  //   final emailRegExp =
  //       RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$');
  //   if (!emailRegExp.hasMatch(test)) {
  //     return 'Veuillez entrer une adresse e-mail valide.';
  //   }
  //   return null;
  // }

  ////refactorisé
  String? _validateEmail(String? value) {
    String test = value ?? "";
    if (!test.contains('@')) {
      return 'Veuillez entrer une adresse e-mail valide.';
    }
    return null;
  }

  String? _validateName(String? value) {
    String test = value ?? "";
    if (test.length < 3) {
      print("Veuillez entrer un nom valide.");
      return 'Veuillez entrer un nom valide.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nom'),
            controller: _nameController,
            keyboardType: TextInputType
                .emailAddress, // Utiliser le clavier d'adresse e-mail
            validator: _validateName,
          ),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Adresse e-mail'),
            controller: _emailController,
            keyboardType: TextInputType
                .emailAddress, // Utiliser le clavier d'adresse e-mail
            validator: _validateEmail,
          ),

          TextFormField(
            decoration: const InputDecoration(labelText: 'Téléphone'),
            controller: _phoneController,
            keyboardType:
                TextInputType.phone, // Utiliser le clavier de telephone
            // validator: _validatePhone, // technical debt
          ),
          const RadioMouF(), //refactor to be row with 2 radio buttons
          CheckboxListTile(
              title: const Text('Accepter les conditions d\'utilisation'),
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              }),
          ElevatedButton(
            onPressed: () {
              if (_acceptTerms) {
                _utilisateur = Utilisateur(
                    _nameController.text,
                    _emailController.text,
                    _phoneController.text,
                    _sexeController.text,
                    _acceptTerms);
                print(_utilisateur);

                final snackBar = SnackBar(
                  content: Text(_utilisateur.toString()),
                  duration: const Duration(
                      seconds: 3), // Durée d'affichage du Snackbar
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {
                      // Code à exécuter lorsque le bouton "Close" est pressé
                    },
                  ),
                );

                // Afficher le Snackbar en utilisant ScaffoldMessenger
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

enum MouF { m, f }

class RadioMouF extends StatefulWidget {
  const RadioMouF({super.key});

  @override
  State<RadioMouF> createState() => _RadioMouFState();
}

class _RadioMouFState extends State<RadioMouF> {
  MouF? _character = MouF.m;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<MouF>(
          title: const Text('Masculin'),
          value: MouF.m,
          groupValue: _character,
          onChanged: (MouF? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<MouF>(
          title: const Text('Féminin'),
          value: MouF.f,
          groupValue: _character,
          onChanged: (MouF? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ],
    );
  }
}

class Utilisateur {
  String nom = "";
  String courriel = "";
  String phone = "";
  String sexe = "";
  bool acceptTerms = false;

// il faut récupérer la valeur de sexe dans le radio button
  Utilisateur(this.nom, this.courriel, this.phone, this.sexe, this.acceptTerms);
  @override
  String toString() {
    return "Usager | nom $nom, courriel: $courriel telephone: $phone sexe $sexe accept $acceptTerms été créé";
  }
}

//// HEX COLOR CONVERSION
//// https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
// extension HexColor on Color {
//   /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
//   static Color fromHex(String hexString) {
//     final buffer = StringBuffer();
//     if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
//     buffer.write(hexString.replaceFirst('#', ''));
//     return Color(int.parse(buffer.toString(), radix: 16));
//   }

//   // Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
//   String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
//       '${alpha.toRadixString(16).padLeft(2, '0')}'
//       '${red.toRadixString(16).padLeft(2, '0')}'
//       '${green.toRadixString(16).padLeft(2, '0')}'
//       '${blue.toRadixString(16).padLeft(2, '0')}';
// }

//// https://stackoverflow.com/questions/71272451/convert-from-hexa-value-to-color-name-in-flutter
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
