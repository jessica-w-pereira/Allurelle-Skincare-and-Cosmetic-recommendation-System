import 'package:flutter/material.dart';

class SkinquizPage extends StatefulWidget {
  const SkinquizPage({Key? key}) : super(key: key);

  @override
  _SkinquizPageState createState() => _SkinquizPageState();
}

class _SkinquizPageState extends State<SkinquizPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<Question> questions = [
    Question(
      questionText: "What is your skin type?",
      options: ["Oily", "Dry", "Normal", "Combination"],
    ),
    Question(
      questionText: "How often do you use sunscreen?",
      options: ["Every day", "Sometimes", "Rarely", "Never"],
    ),
    Question(
      questionText: "Do you have any skin allergies?",
      options: ["Yes", "No", "Not sure"],
    ),
    Question(
      questionText: "How often do you exfoliate your skin?",
      options: ["Daily", "Weekly", "Monthly", "Never"],
    ),
    Question(
      questionText: "What is your age range?",
      options: ["Under 18", "18-24", "25-34", "35-44", "45 and above"],
    ),
    Question(
      questionText: "What is your gender?",
      options: ["Male", "Female", "Other"],
    ),
  ];

  List<String?> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = List<String?>.filled(questions.length, null);
  }

  void _nextPage() {
    if (_currentPage < questions.length) {
      if (_currentPage < questions.length - 1 && selectedOptions[_currentPage] != null) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage += 1;
          _isLastPage = _currentPage == questions.length;
        });
      } else if (_currentPage == questions.length - 1) {
        setState(() {
          _isLastPage = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option before proceeding')),
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage -= 1;
        _isLastPage = false;
      });
    }
  }

  void _submitQuiz() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz submitted successfully!')),
    );
    Navigator.pushReplacementNamed(context, '/homepage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset(
            'assets/allurelle_logo.png',
            height: 50,
            width: 50,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _isLastPage = index == questions.length;
                });
              },
              itemCount: questions.length + 1,
              itemBuilder: (context, index) {
                if (index == questions.length) {
                  return SubmitQuizWidget(onSubmit: _submitQuiz);
                }
                return QuizQuestionWidget(
                  question: questions[index],
                  selectedOption: selectedOptions[index],
                  onOptionSelected: (selectedOption) {
                    setState(() {
                      selectedOptions[index] = selectedOption;
                    });
                  },
                );
              },
            ),
          ),
          if (!_isLastPage)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: const Text("Previous"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF8BBD0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: const Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ),
          if (_isLastPage)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'SkinQuiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/homepage');
              break;
            case 1:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History Clicked')),
              );
              break;
            case 2:
              Navigator.pushNamed(context, '/skinquiz');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}

class QuizQuestionWidget extends StatelessWidget {
  final Question question;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;

  const QuizQuestionWidget({
    Key? key,
    required this.question,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question.questionText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          for (String option in question.options)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  onOptionSelected(option);
                },
                child: Text(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: option == selectedOption ? Colors.pinkAccent : Color(0xFFF8BBD0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SubmitQuizWidget extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitQuizWidget({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please review your answers and submit the quiz.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;

  Question({required this.questionText, required this.options});
}
