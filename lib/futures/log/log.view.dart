import 'dart:developer';

import 'package:chat/futures/log/log.controller.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogView extends GetView<LogController> {
  const LogView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LogController());

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: 'لاگ ها',
        left: IconButton(
          onPressed: () {
            Services.log.clear();
          },
          icon: Icon(
            Icons.delete_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Services.log.stream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text('خطا در بارگذاری'),
                  );
                }

                if (snapshot.hasData) {
                  // empty
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text('لاگی یافت نشد'),
                    );
                  }

                  // expansion panel
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var log = snapshot.data[index];
                      return ExpansionTile(
                        title: Text(
                          log.category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(log.createdAt.toString()),
                        children: [
                          ListTile(
                            title: Text(
                              log.message,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
