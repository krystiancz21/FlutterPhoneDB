import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonedb/models/phoneModel.dart';
import 'package:phonedb/services/PhoneDatabase.dart';

class PhoneScreen extends StatefulWidget {
  final Phone? phone;
  const PhoneScreen({Key? key, this.phone}) : super(key: key);

  @override
  State<PhoneScreen> createState() => PhoneScreenState();
}

class PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController producerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController softVersionController = TextEditingController();
  final TextEditingController avatarPathController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  late FocusNode producerFocusNode;
  late FocusNode modelFocusNode;
  late FocusNode softVersionFocusNode;

  bool producerFocused = false;
  bool modelFocused = false;
  bool softVersionFocused = false;

  void pickImageClick() async {
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        avatarPathController.text = image.path;
      }
    });
  }

  void savePhone() async {
    final producer = producerController.value.text;
    final model = modelController.value.text;
    final softVersion = softVersionController.value.text;
    final picture = avatarPathController.text;

    if (producer.isEmpty || model.isEmpty || softVersion.isEmpty) {
      return;
    }

    final Phone phoneModel = Phone(
        id: widget.phone?.id,
        producer: producer,
        model: model,
        softVersion: softVersion,
        picture: picture);

    if (widget.phone == null) {
      await PhoneDatabase.insertPhone(phoneModel);
    } else {
      await PhoneDatabase.updatePhone(phoneModel);
    }

    if (context.mounted) Navigator.pop(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  String? validateProducerNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {});
      return "Enter producer";
    }
    return null;
  }

  String? validateModelNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {});
      return "Enter model";
    }
    return null;
  }

  String? validateSoftVersionNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {});
      return "Enter software version";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.phone != null) {
      producerController.text = widget.phone!.producer;
      modelController.text = widget.phone!.model;
      softVersionController.text = widget.phone!.softVersion;
      avatarPathController.text = widget.phone!.picture;
    }

    producerFocusNode = FocusNode();
    producerFocusNode.addListener(() {
      if (producerFocusNode.hasFocus != producerFocused) {
        producerFocused = producerFocusNode.hasFocus;
        String? validateResult =
        validateProducerNotEmpty(producerController.text);
        if (!producerFocused && validateResult != null) {
          showSnackBar(validateResult);
        }
      }
    });

    modelFocusNode = FocusNode();
    modelFocusNode.addListener(() {
      if (modelFocusNode.hasFocus != modelFocused) {
        modelFocused = modelFocusNode.hasFocus;
        String? validateResult = validateModelNotEmpty(modelController.text);
        if (!modelFocused && validateResult != null) {
          showSnackBar(validateResult);
        }
      }
    });

    softVersionFocusNode = FocusNode();
    softVersionFocusNode.addListener(() {
      if (softVersionFocusNode.hasFocus != softVersionFocused) {
        softVersionFocused = softVersionFocusNode.hasFocus;
        String? validateResult =
        validateSoftVersionNotEmpty(softVersionController.text);
        if (!softVersionFocused && validateResult != null) {
          showSnackBar(validateResult);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phone == null ? 'Add phone' : 'Edit phone'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: producerController,
                  validator: validateProducerNotEmpty,
                  focusNode: producerFocusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Producer ',
                    labelText: 'Producer*',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: modelController,
                  validator: validateModelNotEmpty,
                  focusNode: modelFocusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Model ',
                    labelText: 'Model*',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: softVersionController,
                  validator: validateSoftVersionNotEmpty,
                  focusNode: softVersionFocusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Software version ',
                    labelText: 'Software version*',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Image.file(File(avatarPathController.text)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: ElevatedButton(
                          onPressed: pickImageClick,
                          child: const Text("Pick image"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savePhone,
        tooltip: 'AddOrEdit',
        child: const Icon(Icons.done),
      ),
    );
  }

  @override
  void dispose() {
    producerController.dispose();
    modelController.dispose();
    softVersionController.dispose();
    producerFocusNode.dispose();
    modelFocusNode.dispose();
    softVersionFocusNode.dispose();
    super.dispose();
  }
}
