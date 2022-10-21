import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/viewModel/main/profile/profile_provider.dart';
import 'package:logger/logger.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider, bool>(
      selector: (_, bloc) => bloc.loadingQrCode,
      builder: (context, state, _)  {
        final token =
            context.select((ProfileProvider bloc) => bloc.getUserToken);
        final timer = context.select((ProfileProvider bloc) => bloc.timer);
        if (token != null) {
          localDB.setString(LocalDBEnum.token.name, token);
          if (timer != null) {
            timer.cancel();
          }
          Navigator.pop(context, true);
        }
        return LoadingView(
          loading: state,
          child: Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Text(
                  "authorization_using_a_qr_code".tr(),
                  style: StyleTextCustom.setStyleByEnum(
                    StyleTextEnum.bodyTitleText,
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Selector<ProfileProvider, String?>(
                      selector: (context, provider) => provider.qrImage,
                      builder: (context, image, child) {
                        if (image != null) {
                          Logger().w(image.toString());
                          return OctoImage(
                            image: NetworkImage(
                                "https://new.matreshkavpn.com/api/v1/auth/qr/image/$image"),
                            progressIndicatorBuilder: (context, progress) {
                              return  Center(
                                child: Text("loading...".tr()),
                              );
                            },
                            errorBuilder: (context, error, stacktrace) =>
                                 Center(
                              child: Text("sorry_didn't_load_image(".tr()),
                            ),
                            fit: BoxFit.cover,
                          );
                        }
                        return  Center(
                          child: Text("sorry_didn't_load_image(".tr()),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "if_you_have_previously_used_the_mobile".tr(),
                    style: StyleTextCustom.setStyleByEnum(
                      StyleTextEnum.bodySubTitleText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
