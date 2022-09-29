import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/style.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            "Авторизация с помощью QR-кода",
            style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bodyTitleText,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTR5fyPfs6QmqvqrxxULxCjq4zC2ld3NdqKvg&usqp=CAU",
              width: 150,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Если вы ранее уже использовали мобильное приложение и имеете существующий авторизированный аккаунт, в разделе «Профиль» вы можете сканировать показанный вам QR-код и пройти авторизацию без подтверждения",
              style: StyleTextCustom.setStyleByEnum(
                StyleTextEnum.bodySubTitleText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
