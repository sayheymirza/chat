import 'dart:io';

import 'package:chat/app/apis/api.dart';
import 'package:chat/futures/dialog_pick_image/dialog_pick_image.view.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class FormBuilderImage extends StatefulWidget {
  final String name;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool disabled;

  const FormBuilderImage({
    super.key,
    required this.name,
    this.labelText,
    this.validator,
    this.disabled = false,
  });

  @override
  State<FormBuilderImage> createState() => _FormBuilderImageWidgetState();
}

class _FormBuilderImageWidgetState extends State<FormBuilderImage> {
  File? file;
  String? url;
  bool uploading = false;
  int uploadProgress = 0;
  CancelToken? cancelToken;

  void choose(FormFieldState field) {
    Get.bottomSheet(const DialogPickImageView(
      editable: false,
    )).then((value) async {
      if (value == null) return;

      if (value['action'] == 'file') {
        file = File(value['data']);
        uploading = true;
        cancelToken = CancelToken();
        setState(() {});

        var result = await ApiService.data.upload(
          file: file!,
          cancelToken: cancelToken,
          callback: ({int percent = 0, int total = 0, int sent = 0}) {
            uploadProgress = percent;
            setState(() {});
          },
        );

        if (result.success) {
          url = result.url;
          field.didChange(url);
        } else {
          uploadProgress = 0;
          uploading = false;
          showSnackbar(message: 'خطا در هنگام آپلود رخ داد');
        }
        setState(() {});
      }
    });
  }

  void unpick(FormFieldState field) {
    file = null;
    url = null;
    uploadProgress = 0;
    uploading = false;

    if (cancelToken != null && !cancelToken!.isCancelled) {
      cancelToken!.cancel();
    }

    field.didChange(null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: widget.name,
      validator: widget.validator,
      builder: (FormFieldState field) {
        return GestureDetector(
          onTap: () {
            choose(field);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.disabled
                        ? Colors.grey.shade300
                        : field.hasError
                            ? Get.theme.colorScheme.error
                            : Colors.grey.shade500,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: file != null || url != null
                    ? Stack(
                        children: [
                          if (file != null)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Image.file(
                                file!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          if (url != null)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Image.network(
                                url!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    unpick(field);
                                  },
                                  child: Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'لغو',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: AnimatedContainer(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: uploadProgress == 100
                                          ? Colors.green.shade100
                                          : Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    duration: const Duration(milliseconds: 100),
                                    child: Center(
                                      child: Text(
                                        uploadProgress == 100
                                            ? 'آپلود شد'
                                            : '$uploadProgress% در حال آپلود',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: uploadProgress == 100
                                              ? Colors.green.shade700
                                              : Colors.blue.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 46,
                            color: widget.disabled
                                ? Colors.grey.shade400
                                : field.hasError
                                    ? Get.theme.colorScheme.error
                                    : null,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.labelText ?? "تصویری انتخاب کنید",
                            style: TextStyle(
                              color: widget.disabled
                                  ? Colors.grey.shade400
                                  : field.hasError
                                      ? Get.theme.colorScheme.error
                                      : null,
                            ),
                          ),
                        ],
                      ),
              ),
              if (field.hasError && field.errorText != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
