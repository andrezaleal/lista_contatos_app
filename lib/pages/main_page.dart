import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_contatos/model/contatos_model.dart';
import 'package:lista_contatos/repositories/contatos_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:brasil_fields/brasil_fields.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ContatosRepository contatosRepository = ContatosRepository();
  var _contatoModel = ContatosModel([]);
  var nomeController = TextEditingController();
  var pathPhotoController = TextEditingController();
  var numeroController = TextEditingController();
  var loading = false;

  XFile? photo;


  @override
  void initState() {
    super.initState();
    obterContatos();
  }

  void obterContatos() async {
    setState(() {
      loading = true;
    });
    _contatoModel = await contatosRepository.readContatos();
    setState(() {
      loading = false;
    });
  }

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      
      setState(() {
       photo = XFile(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Contatos"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                          itemCount: _contatoModel.contato.length,
                          itemBuilder: (BuildContext bc, int index) {
                            var contatos = _contatoModel.contato[index];
                            return Dismissible(
                              onDismissed:
                                  (DismissDirection dismissDirection) async {
                                await contatosRepository
                                    .delete(contatos.objectId);
                                obterContatos();
                              },
                              key: Key(contatos.nome),
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                elevation: 8,
                                shadowColor: Colors.grey,
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Container(
                                          width: 100,
                                          height: 100,
                                          color: const Color.fromARGB(
                                              255, 240, 127, 164),
                                          child: Image.file(
                                              File(contatos.pathPhoto))),
                                      Text("Nome: ${contatos.nome}"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("Número: ${contatos.number}"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 200,
                                              padding: const EdgeInsets.only(
                                                  right: 13.0),
                                              child: Text(
                                                "Foto: ${contatos.pathPhoto}",
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            nomeController.text = "";
            numeroController.text = "";
            photo = XFile("");
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return SingleChildScrollView(
                    child: AlertDialog(
                      title: const Text("Adicionar Contato"),
                      content: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: const Color.fromARGB(
                                        255, 240, 127, 164),
                                    child: Image.file(File(photo?.path ?? "")),
                                   
                                  ),
                                  TextButton.icon(
                                      onPressed: () async {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        final XFile? selectedPhoto =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (selectedPhoto != null) {
                                          String path = (await path_provider
                                                  .getApplicationDocumentsDirectory())
                                              .path;
                                          String name =
                                              basename(selectedPhoto.path);
                                          await selectedPhoto
                                              .saveTo("$path/$name");
                                          await GallerySaver.saveImage(
                                              selectedPhoto.path);
                                          cropImage(selectedPhoto);
                                          setState(() {
                                            photo = selectedPhoto;
                                          });
                                        }
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.camera,
                                        size: 18,
                                      ),
                                      label: const Text("Adicionar foto")),
                                  Container(
                                      width: 200,
                                      padding:
                                          const EdgeInsets.only(right: 13.0),
                                      child: Text(
                                        photo!.path,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              )
                            ],
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: "Nome"),
                            controller: nomeController,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Número"),
                            keyboardType: TextInputType.number,
                            controller: numeroController,
                            inputFormatters: [
                             FilteringTextInputFormatter.digitsOnly,
                             TelefoneInputFormatter()
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await contatosRepository.create(ContatoModel.criar(
                              nomeController.text,
                              photo!.path,
                              numeroController.text,
                            ));
                            Navigator.pop(context);
                            obterContatos();
                            setState(() {});
                          },
                          child: const Text("Salvar"),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
