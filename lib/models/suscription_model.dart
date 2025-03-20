import 'package:flutter/material.dart';

class SuscriptionModel {
  final String title;
  final Icon icon;
  final SuscriptionCat? cat;
  final Map<String, String> desc;
  final Map<String, String> items;
  final double price;

  SuscriptionModel({
    required this.price,
    required this.cat,
    required this.desc,
    required this.items,
    required this.title,
    required this.icon,
  });

  factory SuscriptionModel.fromJson(Map<String, dynamic> json) {
    return SuscriptionModel(
      title: json['title'] as String,
      icon: Icon(IconData(json['icon']['codePoint'], fontFamily: 'MaterialIcons'),
          color: Color(json['icon']['color'])), 
      cat: SuscriptionCat.values.firstWhere(
        (e) => e.toString() == json['cat'],
        orElse: () => SuscriptionCat.free, // Valor por defecto
      ),
      desc: Map<String, String>.from(json['desc']),
      items: Map<String, String>.from(json['items']),
      price:  json['price'] as double,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': {
        'codePoint': icon.icon!.codePoint,
        'size': icon.size,
        'color': icon.color!.value,
      },
      'cat': cat,
      'desc': desc,
      'items': items,
      
    };
  }
}

final infoCard = [
  SuscriptionModel(
    title: 'Free',
    icon: Icon(
      Icons.coffee,
      size: 24,
      color: Colors.black,
    ),
    cat: SuscriptionCat.free,
    desc: {
      'desc01': 'Templates Free',
      'desc02': 'Limitated Chat Bot',
      'desc03': '5 Coins for day IA Chat Bot'
    },
    items: {
      'items01': 'asset/verify.png',
      'items02': 'asset/verify.png',
      'items03': 'asset/verify.png',
    },
    price: 0.0,
  ),
  SuscriptionModel(
    title: 'Premium',
    icon: Icon(
      Icons.coffee,
      size: 24,
      color: Colors.black,
    ),
    cat: SuscriptionCat.premium,
    desc: {
      'desc01': 'Templates Premium',
      'desc02': 'Unlimited Chat Bot',
      'desc03': '10 Coins for day IA Chat Bot'
    },
    items: {
      'items01': 'asset/verify.png',
      'items02': 'asset/verify.png',
      'items03': 'asset/verify.png',
    },
    price: 5.0,
  ),
];

enum SuscriptionCat { free, premium }
