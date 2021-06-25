import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../enumerations.dart';

class QuizSettings extends StatefulWidget {
  final Function handleStart;
  QuizSettings({@required this.handleStart});

  @override
  _QuizSettingsState createState() => _QuizSettingsState(handleStart);
}

class _QuizSettingsState extends State<QuizSettings> {
  final Function handleStart;
  _QuizSettingsState(this.handleStart);

  final _formKey = GlobalKey<FormState>();
  QuizFormat format = QuizFormat.en_jp;
  QuizCategory category = QuizCategory.common;
  int questionAmount = 1;

  @override
  Widget build(BuildContext context) {
    Widget quizSettingsForm = Form(
      key: _formKey,
      child: Expanded(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Format'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButtonFormField<QuizFormat>(
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                      value: format,
                      onChanged: (QuizFormat value){
                        setState(() {
                          format = value;
                        });
                      },
                      validator: (QuizFormat value) {
                        if (value == null) {
                          return 'Please select a format';
                        }
                        return null;
                      },
                      items: QUIZ_FORMAT_OPTIONS.entries.map((entry) {
                        return DropdownMenuItem<QuizFormat>(
                          value: entry.key,
                          child: Text(entry.value)
                        );
                      }).toList()
                    )
                  )
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButtonFormField<QuizCategory>(
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                      value: category,
                      onChanged: (QuizCategory value){
                        setState(() {
                          category = value;
                        });
                      },
                      validator: (QuizCategory value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      items: QUIZ_CATEGORY_OPTIONS.entries.map((entry) {
                        return DropdownMenuItem<QuizCategory>(
                          value: entry.key,
                          child: Text(entry.value)
                        );
                      }).toList()
                    )
                  )
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number of Questions'),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                    inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (String value) {
                      setState(() {
                        questionAmount = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (String value) {
                      int n = int.parse(value);
                      if (value == null || value.isEmpty || n < 1 || n > 20) {
                        return 'Please enter a number between 1 and 20';
                      }
                      return null;
                    },
                    initialValue: questionAmount.toString(),
                  )
                ],
              )
            )
          ]
        )
      )
    );

    Widget submitButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20)
      ),
      onPressed: (){
        if (_formKey.currentState.validate()) {
          handleStart(format, category, questionAmount);
        }
      },
      child: Text('Start'),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          quizSettingsForm,
          submitButton
        ]
      )
    );
  }
}