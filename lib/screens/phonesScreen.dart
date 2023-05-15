import 'package:flutter/material.dart';

import '../models/phoneModel.dart';
import '../services/PhoneDatabase.dart';
import '../widgets/phoneWidget.dart';
import 'phoneScreen.dart';

class PhonesScreen extends StatefulWidget {
  const PhonesScreen({Key? key}) : super(key: key);

  @override
  State<PhonesScreen> createState() => _PhonesScreenState();
}

class _PhonesScreenState extends State<PhonesScreen> {
  void _deletePhone(Phone phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this phone?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await PhoneDatabase.deletePhone(phone);
              setState(() {});
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _editPhone(Phone phone) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneScreen(phone: phone),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Phones'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PhoneScreen()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Phone>?>(
        future: PhoneDatabase.getPhones(),
        builder: (context, AsyncSnapshot<List<Phone>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => PhoneWidget(
                  phone: snapshot.data![index],
                  deleteClick: () {
                    _deletePhone(snapshot.data![index]);
                  },
                  editClick: () {
                    _editPhone(snapshot.data![index]);
                  },
                ),
                itemCount: snapshot.data!.length,
              );
            }
            return const Center(
              child: Text('No phones yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
