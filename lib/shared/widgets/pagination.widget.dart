import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaginationWidget extends StatefulWidget {
  final int last;
  final int page;
  final Function(int page) onChange;
  final Color? color;
  final bool elevation;
  final bool hidden;

  const PaginationWidget({
    super.key,
    required this.last,
    required this.page,
    required this.onChange,
    this.elevation = false,
    this.hidden = false,
    this.color,
  });

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text = widget.page.toString();
  }

  @override
  void didUpdateWidget(covariant PaginationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller.text = widget.page.toString();
  }

  void setPage(int value) {
    setState(() {
      controller.text = value.toString();
      widget.onChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.hidden || widget.last == 0
        ? Container(
            height: 0,
          )
        : Container(
            margin: EdgeInsets.only(
              bottom: 36,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              // elevation
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // last button
                    ElevatedButton(
                      onPressed: () {
                        setPage(widget.last);
                      },
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(Size(46, 46)),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 14,
                          ),
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor: WidgetStatePropertyAll(
                          widget.color == null
                              ? Get.theme.colorScheme.secondaryContainer
                              : widget.color!.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'آخرین (${widget.last})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (widget.page < widget.last) const Gap(6),
                    if (widget.page < widget.last)
                      ElevatedButton(
                        onPressed: () {
                          setPage(widget.page + 1);
                        },
                        style: ButtonStyle(
                          minimumSize:
                              const WidgetStatePropertyAll(Size(46, 46)),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 0,
                            ),
                          ),
                          elevation: const WidgetStatePropertyAll(0),
                          backgroundColor: WidgetStatePropertyAll(
                            widget.page < widget.last
                                ? widget.color == null
                                    ? Get.theme.colorScheme.secondaryContainer
                                    : widget.color!.withOpacity(0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          widget.page < widget.last
                              ? (widget.page + 1).toString()
                              : '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    const Gap(6),
                    ElevatedButton(
                      onPressed: null,
                      // border side
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(Size(46, 46)),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          ),
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor: WidgetStatePropertyAll(
                          widget.color ?? Get.theme.primaryColor,
                        ),
                      ),
                      child: Text(
                        widget.page.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(6),
                    if (widget.page > 1)
                      ElevatedButton(
                        onPressed: () {
                          setPage(widget.page - 1);
                        },
                        style: ButtonStyle(
                          minimumSize:
                              const WidgetStatePropertyAll(Size(46, 46)),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 0,
                            ),
                          ),
                          elevation: const WidgetStatePropertyAll(0),
                          backgroundColor: WidgetStatePropertyAll(
                            widget.page > 1
                                ? widget.color == null
                                    ? Get.theme.colorScheme.secondaryContainer
                                    : widget.color!.withOpacity(0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          widget.page == 1 ? '' : (widget.page - 1).toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    if (widget.page > 1) const Gap(6),
                    // first button
                    ElevatedButton(
                      onPressed: () {
                        setPage(1);
                      },
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(Size(46, 46)),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 14,
                          ),
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor: WidgetStatePropertyAll(
                          widget.color == null
                              ? Get.theme.colorScheme.secondaryContainer
                              : widget.color!.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'اولین',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 48,
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(4),
                    ElevatedButton(
                      onPressed: () {
                        widget.onChange(int.parse(controller.text));
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          widget.color ?? Get.theme.primaryColor,
                        ),
                        minimumSize: const WidgetStatePropertyAll(Size(46, 46)),
                      ),
                      child: const Text(
                        'برو',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
