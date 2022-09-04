import 'package:flutter/material.dart';
import 'package:flutter_desctop/view/main/subscription/local_widgets/price_box.dart';
import 'package:flutter_desctop/view/main/subscription/local_widgets/title_with_subtitle_box.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset(
              "assets/images/subscription_page_header.png",
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 15),
            const TitleWithSubTitleBox(
              title: "Доступ к заблокиро-ванным сервисам",
              subTitle:
                  "Получите доступ ко всем заблокированным сервисам, Instagram, Facebook, Youtube",
              icon: "assets/icons/flash.png",
            ),
            const SizedBox(height: 15),
            const TitleWithSubTitleBox(
              title: "Какая-нибудь фича",
              subTitle: "",
              icon: "assets/icons/shield.png",
            ),
            const SizedBox(height: 15),
            const TitleWithSubTitleBox(
              title: "Какая-нибудь фича",
              subTitle:
                  "Приложение для приема СМС сообщений на виртуальные телефонные номера ",
              icon: "assets/icons/flash.png",
            ),
            const SizedBox(height: 15),
            const PriceBox(title: "Получить Бесплатно", price: ""),
            const PriceBox(title: "1 Месяц", price: "199₽"),
            const PriceBox(title: "3 Месяц", price: "499₽"),
            const PriceBox(title: "1 Год", price: "1599₽"),
            _bottomTextButtons(),
          ],
        ),
      ),
    );
  }

  Row _bottomTextButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _bottomTextButtonItem("Публичная оферта"),
        _bottomTextButtonItem("Политика Конфиденциальности"),
      ],
    );
  }

  MouseRegion _bottomTextButtonItem(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
