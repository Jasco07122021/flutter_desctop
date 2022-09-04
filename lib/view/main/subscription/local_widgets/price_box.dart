import 'package:flutter/material.dart';
import 'package:flutter_desctop/view/main/subscription/local_widgets/bottom_sheet.dart';

class PriceBox extends StatelessWidget {
  final String title;
  final String price;

  const PriceBox({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            onTap: () {
             if(price.isNotEmpty) {
               showModalBottomSheet(
                backgroundColor: const Color(0xFF131A2E),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),
                context: context,
                isScrollControlled: true,
                builder: (context) => BottomSheetSubscriptionView(
                  header: title,
                  price: price,
                ),
              );
             }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: price.isEmpty ? Colors.teal : Colors.blue,
                width: 1.5,
              ),
            ),
            dense: price.isEmpty ? true : false,
            tileColor: price.isEmpty
                ? const Color.fromRGBO(31, 178, 148, 0.161604)
                : const Color.fromRGBO(9, 152, 212, 0.1),
            leading: price.isEmpty
                ? const Icon(
                    Icons.favorite,
                    size: 18,
                  )
                : Image.asset(
                    "assets/icons/discount.png",
                    height: 20,
                    width: 20,
                  ),
            minLeadingWidth: 10,
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (price == "499₽" || price == "1599₽")
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "Скидка: ${price == "499₽" ? 16 : 32}%",
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
