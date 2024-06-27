import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item_model.dart';

class ItemService {
  static const String url = 'http://192.168.56.1:3000/items';

  static Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar items');
    }
  }

  static Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': item.name,
        'quantity': item.quantity,
        'available': item.available,
        'addedDate': item.addedDate.toIso8601String(),
      }),
    );
    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear item: ${response.statusCode}');
    }
  }

  static Future<Item> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse('$url/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar item: ${response.statusCode}');
    }
  }

  static Future<void> deleteItem(String id) async {
    final response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar item: ${response.statusCode}');
    }
  }
}
