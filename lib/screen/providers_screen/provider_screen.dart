import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/provider.dart';
import 'package:flutter_application_1/services/provider_service.dart';

class ProviderScreen extends StatefulWidget {
  @override
  _ProviderScreenState createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  final ProviderService _providerService = ProviderService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Providers'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false);
          },
        ),
      ),
      body: FutureBuilder<ProviderList>(
        future: _providerService.getProviderList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final providers = snapshot.data?.providers ?? [];
            return ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];
                return ListTile(
                  title: Text(provider.providerName),
                  subtitle: Text('Last Name: ${provider.providerLastName}\nMail: ${provider.providerMail}\nState: ${provider.providerState}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editProvider(provider);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProvider(provider);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProvider();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editProvider(Provider provider) async {
    final result = await _showEditProviderDialog(provider.providerName, provider.providerLastName, provider.providerMail, provider.providerState);
    if (result != null) {
      try {
        await _providerService.editProvider(
          provider.providerId,
          result['providerName'] ?? '',
          result['providerLastName'] ?? '',
          result['providerMail'] ?? '',
          result['providerState'] ?? '',
        );
        setState(() {});
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit provider: $error'),
          ),
        );
      }
    }
  }

  Future<Map<String, String>?> _showEditProviderDialog(String currentName, String currentLastName, String currentMail, String currentState) async {
    String newName = currentName;
    String newLastName = currentLastName;
    String newMail = currentMail;
    String newState = currentState;

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: currentName),
              decoration: InputDecoration(labelText: 'New Provider Name'),
              onChanged: (value) => newName = value,
            ),
            TextField(
              controller: TextEditingController(text: currentLastName),
              decoration: InputDecoration(labelText: 'New Provider Last Name'),
              onChanged: (value) => newLastName = value,
            ),
            TextField(
              controller: TextEditingController(text: currentMail),
              decoration: InputDecoration(labelText: 'New Provider Mail'),
              onChanged: (value) => newMail = value,
            ),
            TextField(
              controller: TextEditingController(text: currentState),
              decoration: InputDecoration(labelText: 'New Provider State'),
              onChanged: (value) => newState = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'providerName': newName,
                'providerLastName': newLastName,
                'providerMail': newMail,
                'providerState': newState,
              });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteProvider(Provider provider) async {
    try {
      await _providerService.deleteProvider(provider.providerId);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete provider: $error'),
        ),
      );
    }
  }

  void _addProvider() async {
    final result = await _showAddProviderDialog();
    if (result != null) {
      try {
        await _providerService.addProvider(result);
        setState(() {});
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add provider: $error'),
          ),
        );
      }
    }
  }

  Future<Map<String, String>?> _showAddProviderDialog() async {
    String newName = '';
    String newLastName = '';
    String newMail = '';
    String newState = '';

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Provider Name'),
              onChanged: (value) => newName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Provider Last Name'),
              onChanged: (value) => newLastName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Provider Mail'),
              onChanged: (value) => newMail = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Provider State'),
              onChanged: (value) => newState = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'providerName': newName,
                'providerLastName': newLastName,
                'providerMail': newMail,
                'providerState': newState,
              });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
