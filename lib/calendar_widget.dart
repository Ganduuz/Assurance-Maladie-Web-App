import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  int _selectedYear = DateTime.now().year;
double itemHeight = 60.0; // Hauteur de chaque élément
  double dropdownHeight = 150.0; // Hauteur totale de la liste déroulante
 TextEditingController dobController=TextEditingController(); 
 
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 460, // Increased height to accommodate year picker
            width: 380,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  DropdownButton<int>(
                        value: _selectedYear,
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedYear = newValue!;
                            _selectedDate = DateTime(_selectedYear, _selectedDate.month, _selectedDate.day);
                          });
                        },
                         items: List.generate(100, (index) => DateTime.now().year - 50 + index)
                            .map((int value) {
                          return DropdownMenuItem<int>(
                            
                            value: value,
                            child: SizedBox(
                              height: itemHeight,
                              child: Center(child: Text(value.toString())),
                            ),
                          );
                        }).toList(),
                        itemHeight: itemHeight, // Hauteur de chaque élément du dropdown
                        menuMaxHeight: dropdownHeight, // Hauteur totale de la liste déroulante
                      ),
                  TableCalendar(
                    focusedDay: _selectedDate,
                    firstDay: DateTime.utc(1950),
                    lastDay: DateTime.utc(2100),
                    rowHeight: 35,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontWeight: FontWeight.w400),
                      weekendStyle: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        _selectedDate = selectDay;
                        _selectedYear = selectDay.year;
                        // Assuming dobController is declared somewhere else in your code
                        dobController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
                      });
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                    ),
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(_selectedDate, date);
                    },
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {   
                            Navigator.pop(context, _selectedDate);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.blue.shade300),
                          ),
                        ),
                      ),
                      SizedBox(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Annuler",
                          style: TextStyle(color: Colors.blue.shade300),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
     },
);
}
}