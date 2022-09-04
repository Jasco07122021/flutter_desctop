import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/model/local_model/bank_card_model.dart';

class BottomSheetSubscriptionView extends StatelessWidget {
  final String header;
  final String price;

  const BottomSheetSubscriptionView({
    Key? key,
    required this.header,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40, right: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Expanded(
                child: Text(
                  "$header премиум",
                  style: StyleTextCustom.setStyleByEnum(
                    StyleTextEnum.bottomSheetHeaderText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Стоимость:"),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ColoredBox(
                  color: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    child: Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (BankCard bankCard in listBankCard)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                tileColor: Colors.grey.withOpacity(0.05),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bankCard.color,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(bankCard.img),
                ),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  bankCard.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(bankCard.subtitle),
              ),
            ),
        ],
      ),
    );
  }
}
