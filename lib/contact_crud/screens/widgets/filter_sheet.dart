import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final String selectedValue;

  const FilterSheet({super.key, required this.selectedValue});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String filterValue = "All";
  final List contactTypeList = ["All", "Family", "Friend", "Business"];

  @override
  void initState() {
    super.initState();
    filterValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    final buildWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Filter by Contact Type",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            children: List.generate(
                contactTypeList.length,
                (index) => InkWell(
                      radius: 8,
                      child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: contactTypeList[index] == filterValue
                                    ? Colors.blue
                                    : Colors.black)),
                        backgroundColor: Colors.white,
                        label: Text(contactTypeList[index]),
                        labelStyle: TextStyle(
                            color: contactTypeList[index] == filterValue
                                ? Colors.blue
                                : Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          filterValue = contactTypeList[index];
                        });
                      },
                    )),
          ),
        ),
        Container(
          width: buildWidth,
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: ElevatedButton(
              onPressed: () => Navigator.pop(context, filterValue),
              child: const Text("Apply")),
        )
      ],
    );
  }
}
