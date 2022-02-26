import 'package:flutter/material.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({Key? key}) : super(key: key);

  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final _formKey = GlobalKey<FormState>();
  String? _cityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'City Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a city name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cityName = value;
                },
              ),
              ElevatedButton(
                child: const Text('Search'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, _cityName);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}