// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

class SuscriptionModel {
  final String title;
  final Icon icon;
  final SuscriptionCat? cat;
  final Map<String, String> desc;
  final Map<String, String> items;
  final double? price;

  SuscriptionModel({
    this.price,
    required this.cat,
    required this.desc,
    required this.items,
    required this.title,
    required this.icon,
  });
}

final List<SuscriptionModel> infoCard = [
  SuscriptionModel(
    title: 'Free',
    icon: const Icon(Icons.coffee, size: 100, color: Colors.white),
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
    cat: SuscriptionCat.free,
  ),
  SuscriptionModel(
      price: 4.99,
      title: 'Premium',
      desc: {
        'desc01': 'Templates Premium',
        'desc02': 'Ilimitated Chat Bot',
        'desc03': 'Ilimitates coins IA Chat Bot'
      },
      items: {
        'items01': 'asset/verify.png',
        'items02': 'asset/verify.png',
        'items03': 'asset/verify.png',
      },
      icon: const Icon(
        Icons.rocket,
        size: 100,
        color: Colors.white,
      ),
      cat: SuscriptionCat.premium),
];

enum SuscriptionCat { free, premium }