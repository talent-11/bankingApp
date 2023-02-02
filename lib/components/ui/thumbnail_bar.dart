import 'package:flutter/material.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/models/account_model.dart';

class ThumbnailBar extends StatelessWidget {
  const ThumbnailBar(
    {
      Key? key,
      required this.user,
      required this.onPressedQrCode,
    }
  ) : super(key: key);
     
  final AccountModel user;
  final Function onPressedQrCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.qr_code, size: 48, color: Colors.white),
            onPressed: () => onPressedQrCode(context),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name!, 
              style: TextStyle(
                color: Theme.of(context).primaryColor, 
                decoration: TextDecoration.underline, 
                decorationThickness: 1.5,
                fontSize: 18, 
                fontWeight: FontWeight.w500
              )
            ),
            Text(
              "@" + user.username!,
              style: Theme.of(context).textTheme.headline6,
            ),
            user.verifiedId != "--" ? const SizedBox(height: 2) : const SizedBox(width: 0, height: 0),
            user.verifiedId != "--" ? Text("Your referral code is " + user.referralId!, style: Theme.of(context).textTheme.headline6) : const SizedBox(width: 0, height: 0),
            user.verifiedId != "--" ? const SizedBox(height: 4) : const SizedBox(width: 0, height: 0),
            user.verifiedId != "--" ? 
              const TextWithCC(text: ("Invite friends, earn {{s}}1,000"), fontSize: 14, color: Colors.lightBlue, lineHeight: 1.0) : 
              const SizedBox(width: 0, height: 0)
          ],
        )
      ]
    );
  }
}
