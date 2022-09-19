import 'package:flutter/material.dart';

class BankCard {
  final String img;
  final String title;
  final String subtitle;
  final Color color;

  BankCard(this.img, this.title, this.subtitle, this.color);
}

List<BankCard> listBankCard = [
  BankCard(
    "assets/icons/bank_card.png",
    "Банковская карта",
    " Мир, Visa, MasterCard, Union Pay ",
    const Color.fromRGBO(9, 152, 212, 0.140734),
  ),
  // BankCard(
  //   "assets/icons/qiwi.png",
  //   "QIWI",
  //   "Электронный кошелёк ",
  //   const Color.fromRGBO(212, 59, 9, 0.140734),
  // ),
  // BankCard(
  //   "assets/icons/ios.png",
  //   "Apple Pay",
  //   "Для пользователей Apple",
  //   const Color.fromRGBO(255, 255, 255, 0.140734),
  // ),
  // BankCard(
  //   "assets/icons/weChat.png",
  //   "WeChat Pay",
  //   "Для пользователей из Китая",
  //   const Color.fromRGBO(69, 255, 0, 0.0939412),
  // ),
];
