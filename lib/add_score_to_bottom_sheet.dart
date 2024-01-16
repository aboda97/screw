import 'package:flutter/material.dart';
import 'package:screw_app/app_constants.dart';

class AddToModalBottomSheet extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final Function(List<int>) addScoreCallback;
  final VoidCallback removeLastRoundCallback;
  final VoidCallback doubleScoresCallback;

  const AddToModalBottomSheet({
    Key? key,
    required this.numberOfPlayers,
    required this.playerNames,
    required this.addScoreCallback,
    required this.removeLastRoundCallback,
    required this.doubleScoresCallback,
  }) : super(key: key);

  @override
  State<AddToModalBottomSheet> createState() => _AddToModalBottomSheetState();
}

class _AddToModalBottomSheetState extends State<AddToModalBottomSheet> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.numberOfPlayers,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListView(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 0,
              childAspectRatio: 5 / 2,
            ),
            itemCount: widget.playerNames.length,
            itemBuilder: (BuildContext context, int index) {
              return TextFormField(
                controller: controllers[index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: widget.playerNames[index],
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColor.kBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColor.kBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColor.kBorderColor,
                    ),
                  ),
                ),
                maxLines: 1,
                minLines: 1,
              );
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColor.kAppBarColor),
            ),
            onPressed: () {
              List<int> scores = controllers
                  .map((controller) => int.tryParse(controller.text) ?? 0)
                  .toList();
              widget.addScoreCallback(scores);
              Navigator.pop(context);
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColor.kAppBarColor),
            ),
            onPressed: () {
              widget.doubleScoresCallback();
              Navigator.pop(context);
            },
            child: const Text(
              'Double x2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColor.kAppBarColor),
            ),
            onPressed: () {
              widget.removeLastRoundCallback();
              Navigator.pop(context);
            },
            child: const Text(
              'إحذف أخر جوله',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
