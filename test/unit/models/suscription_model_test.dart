import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';

void main() {
  test('SuscriptionModel Test', () {
    final json = {
      'title': 'Free',
      'icon': {
        'codePoint': Icons.coffee.codePoint,
        'color': Colors.black.value,
      },
      'cat': 'SuscriptionCat.free',
      'desc': {
        'desc01': 'Templates Free',
        'desc02': 'Limitated Chat Bot',
        'desc03': '5 Coins for day IA Chat Bot'
      },
      'items': {
        'items01': 'asset/verify.png',
        'items02': 'asset/verify.png',
        'items03': 'asset/verify.png',
      },
      'price': 4.0,
    };
    final suscription = SuscriptionModel.fromJson(json);

    expect(suscription.title, 'Free');
    expect(suscription.icon.icon, Icons.coffee);
    expect(suscription.cat, SuscriptionCat.free);
    expect(suscription.desc['desc01'], 'Templates Free');
    expect(suscription.items['items01'], 'asset/verify.png');
    expect(suscription.price, 4.0);
  });
}
