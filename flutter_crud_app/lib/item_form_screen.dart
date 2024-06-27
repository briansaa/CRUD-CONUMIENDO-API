import 'package:flutter/material.dart';
import 'item_model.dart';
import 'item_service.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  ItemFormScreen({this.item});

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  late bool _available;
  late DateTime _addedDate;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _name = widget.item!.name;
      _quantity = widget.item!.quantity;
      _available = widget.item!.available;
      _addedDate = widget.item!.addedDate;
    } else {
      _name = '';
      _quantity = 0;
      _available = false;
      _addedDate = DateTime.now();
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Item item = Item(
        id: widget.item?.id ?? '',
        name: _name,
        quantity: _quantity,
        available: _available,
        addedDate: _addedDate,
      );

      try {
        if (widget.item == null) {
          await ItemService.createItem(item);
        } else {
          await ItemService.updateItem(item);
        }
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _addedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _addedDate)
      setState(() {
        _addedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Crear item' : 'Actualizar item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantity = int.parse(value!);
                },
              ),
              SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Text('Disponible'),
                  Checkbox(
                    value: _available,
                    onChanged: (value) {
                      setState(() {
                        _available = value!;
                      });
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text(
                  "Fecha agregada: ${_addedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(widget.item == null ? 'Crear' : 'Actualizar'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
