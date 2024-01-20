import 'package:flutter/material.dart';
import 'package:screw_app/app_constants.dart';
import 'package:screw_app/second_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPlayers = 2;
  List<TextEditingController> nameControllers = [];

  @override
  void initState() {
    super.initState();
    nameControllers = List.generate(
      selectedPlayers,
      (index) => TextEditingController(),
    );
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'فلسطين حرة',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.pan_tool_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const Text(
                'Swipe to Choose Number of Players',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.kNumOfPlayers,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    int numberOfPlayers = index + 2;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPlayers = numberOfPlayers;
                          nameControllers = List.generate(
                            selectedPlayers,
                            (index) => TextEditingController(),
                          );
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: selectedPlayers == numberOfPlayers
                              ? AppColor.kActiveNumOfPlayers
                              : AppColor.kNumOfPlayers,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$numberOfPlayers Player',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Center(
                child: Text(
                  'Please Enter Names',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: selectedPlayers * 100.0, // Adjust the height as needed
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    selectedPlayers,
                    (index) => Column(
                      children: [
                        TextFormField(
                          controller: nameControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Player ${index + 1}',
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColor.kBorderColor,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          minLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                            height:
                                8), // Add space between TextFormField widgets
                      ],
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColor.kAppBarColor),
                    ),
                    onPressed: () {
                      bool validate = formKey.currentState!.validate();
                      if (validate) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScoreBoard(
                              numberOfPlayers: selectedPlayers,
                              playerNames: nameControllers
                                  .map((controller) => controller.text)
                                  .toList(),
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    child: const Text(
                      'Go to the Scoreboard Screen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
