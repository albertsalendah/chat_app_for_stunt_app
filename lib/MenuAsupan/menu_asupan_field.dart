import 'package:flutter/material.dart';

class MenuAsupanField extends StatefulWidget {
  final String label;
  final String hint;
  final String hintM;
  final List<String> list;
  final TextEditingController mainController;
  final TextEditingController countController;
  final TextEditingController measurementController;
  const MenuAsupanField(
      {super.key,
      required this.label,
      required this.hint,
      required this.hintM,
      required this.list,
      required this.mainController,
      required this.countController,
      required this.measurementController});

  @override
  State<MenuAsupanField> createState() => _MenuAsupanFieldState();
}

class _MenuAsupanFieldState extends State<MenuAsupanField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.measurementController.text = widget.hintM;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            TextField(
              controller: widget.mainController,
              decoration: InputDecoration(
                  hintText: 'Contoh : ${widget.hint}',
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1))),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: widget.countController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    decoration: const InputDecoration(
                        hintText: "0", border: InputBorder.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: widget.measurementController,
                    readOnly: true,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                        hintText: widget.hintM,
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.arrow_drop_down)),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                          child: Text(
                                        'Banyaknya',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.close)),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 335,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.list.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      title: Text(widget.list[index]),
                                      onTap: () {
                                        widget.measurementController.text =
                                            widget.list[index];
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ],
    );
  }
}
