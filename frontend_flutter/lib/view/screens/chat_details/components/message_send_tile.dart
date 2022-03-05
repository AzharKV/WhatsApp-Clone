import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_clone/const_files/my_color.dart';
import 'package:whatsapp_clone/controller/chat_controller.dart';
import 'package:whatsapp_clone/view/widgets/sizedBox.dart';

class MessageSendTile extends StatelessWidget {
  const MessageSendTile({
    Key? key,
    required this.chatController,
    required this.userId,
  }) : super(key: key);

  final ChatController chatController;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0) +
          const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints:
                  const BoxConstraints(maxHeight: 130.0, minHeight: 45.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22.0)),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                      size: 26.0,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: chatController.messageTextField,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16.0),
                      onChanged: (String value) =>
                          chatController.textControllerValue.value = value,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0) +
                                  const EdgeInsets.only(bottom: 4.0),
                          hintText: "Message",
                          hintStyle: const TextStyle(
                              fontSize: 18.0, color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                      size: 24.0,
                    ),
                  ),
                  Obx(() => Visibility(
                        visible:
                            chatController.textControllerValue.value.isEmpty
                                ? true
                                : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.paid,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ),
                        ),
                      )),
                  Obx(
                    () => Visibility(
                      visible: chatController.textControllerValue.value.isEmpty
                          ? true
                          : false,
                      child: InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                  sizedBoxW4,
                ],
              ),
            ),
          ),
          sizedBoxW4,
          InkWell(
            onTap: () => chatController.sendMessage(userId),
            child: Container(
              width: 45.0,
              height: 45.0,
              decoration: const BoxDecoration(
                  color: MyColor.buttonColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Obx(
                () => Icon(
                    chatController.textControllerValue.value.isEmpty
                        ? Icons.mic
                        : Icons.send,
                    size: 25.0,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
