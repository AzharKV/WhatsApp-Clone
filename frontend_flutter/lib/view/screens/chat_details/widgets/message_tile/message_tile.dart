import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

import 'clip_l_thread.dart';
import 'clip_r_thread.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    this.myMessage = true,
    this.firstMessage = true,
    required this.messageText,
    this.send = false,
    this.received = false,
    this.opened = false,
    this.index = 0,
    required this.dateTime,
  }) : super(key: key);

  final bool myMessage, firstMessage, send, received, opened;
  final String messageText;
  final int index;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: myMessage ? Alignment.topRight : Alignment.topLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!myMessage && firstMessage)
            ClipPath(
              clipper: ClipLThread(),
              child: Container(
                height: 10.0,
                width: 7.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
          Container(
            constraints:
                BoxConstraints(minHeight: 40.0, maxWidth: Get.width / 1.25),
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: myMessage ? MyColor.chatBoxColor : Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(12.0),
                bottomRight: const Radius.circular(12.0),
                topRight:
                    Radius.circular(firstMessage && myMessage ? 0.0 : 12.0),
                topLeft:
                    Radius.circular(firstMessage && !myMessage ? 0.0 : 12.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  messageText,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 14.0),
                ),
                sizedBoxH2,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat("hh.m a").format(dateTime),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 10.0),
                    ),
                    sizedBoxW4,
                    if (myMessage)
                      if (opened)
                        const Icon(Icons.done_all,
                            size: 14.0, color: Colors.blue)
                      else if (received)
                        const Icon(Icons.done_all, size: 14.0)
                      else
                        const Icon(Icons.check, size: 14.0)
                  ],
                ),
              ],
            ),
          ),
          if (myMessage && firstMessage)
            ClipPath(
              clipper: ClipRThread(),
              child: Container(
                height: 10.0,
                width: 10.0,
                decoration: const BoxDecoration(color: MyColor.chatBoxColor),
              ),
            ),
        ],
      ),
    );
  }
}
