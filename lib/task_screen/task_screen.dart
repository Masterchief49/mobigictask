import 'package:flutter/material.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  _MyTaskScreenState createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  final int rows = 3;
  final int columns = 4;
  final TextEditingController textController = TextEditingController();
  List<String> gridData = List.generate(3 * 4, (index) => '');
  List<int> highlightedIndices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1
                )
              ),

              child: TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Enter text to search'),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: rows * columns,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: highlightedIndices.contains(index)
                          ? Colors.yellow
                          : null,
                    ),
                    child: TextField(
                      controller: TextEditingController(text: gridData[index]),
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          gridData[index] = value.isNotEmpty ? value[0] : '';
                        });
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.text,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(textController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter text to search')),
                      );
                    } else {
                      highlightMatchingText();
                    }
                  },
                  child: const Text('Search and Highlight'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Reset the setup
                    resetSetup();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void highlightMatchingText() {
    String searchText = textController.text.toLowerCase();
    highlightedIndices.clear();

    bool textFound = false; // Flag to check if the text is found

    for (int i = 0; i < gridData.length; i++) {
      if (gridData[i].toLowerCase() == searchText) {
        if (i % columns + searchText.length <= columns) {
          for (int j = 0; j < searchText.length; j++) {
            highlightedIndices.add(i + j);
          }
        }

        if (i + searchText.length * columns <= gridData.length) {
          for (int j = 0; j < searchText.length; j++) {
            highlightedIndices.add(i + j * columns);
          }
        }

        if (i % columns + searchText.length <= columns &&
            i + searchText.length * columns <= gridData.length) {
          for (int j = 0; j < searchText.length; j++) {
            highlightedIndices.add(i + j + j * columns);
          }
        }

        textFound = true;
      }
    }

    if (!textFound) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Text Not Found'),
          content:const Text('The entered text does not exist in the grid.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {});
  }

  void resetSetup() {
    setState(() {
      textController.clear();
      gridData = List.generate(rows * columns, (index) => '');
      highlightedIndices.clear();
    });
  }
}