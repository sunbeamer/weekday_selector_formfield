library weekday_selector_formfield;

import 'package:flutter/material.dart';

class WeekDaySelectorFormField extends StatefulWidget {
  const WeekDaySelectorFormField(
      {Key key,
      this.autovalidate = false,
      this.enabled = true,
      this.onChange,
      this.onSaved,
      this.validator,
      this.displayDays = const [
        days.monday,
        days.tuesday,
        days.wednesday,
        days.thursday,
        days.friday,
        days.saturday,
        days.sunday
      ],
      this.language = lang.en,
      this.selectedFillColor,
      this.fillColor,
      this.highlightColor,
      this.splashColor,
      this.borderSide = const BorderSide(color: Colors.black, width: 1),
      this.initialValue,
      this.textStyle = const TextStyle(color: Colors.black),
      this.errorTextStyle = const TextStyle(color: Colors.red),
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      this.mainAxisSize = MainAxisSize.min,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.borderRadius = 8,
      this.elevation = 4.0})
      : super(key: key);

  final List<days> initialValue;
  final void Function(List<days>) onChange;
  final void Function(List<days>) onSaved;
  final String Function(List<days>) validator;
  final List<days> displayDays;
  final lang language;
  final Color fillColor;
  final Color selectedFillColor;
  final Color highlightColor;
  final Color splashColor;
  final BorderSide borderSide;
  final TextStyle textStyle;
  final TextStyle errorTextStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool autovalidate;
  final bool enabled;
  final double borderRadius;
  final double elevation;

  static const workDays = [
    days.monday,
    days.tuesday,
    days.wednesday,
    days.thursday,
    days.friday
  ];

  static const weekendDays = [
    days.saturday,
    days.sunday,
  ];

  @override
  _WeekDaySelectorFormFieldState createState() =>
      _WeekDaySelectorFormFieldState();
}

class _WeekDaySelectorFormFieldState extends State<WeekDaySelectorFormField> {
  List<Widget> displayedDays = [];
  List<days> daysSelected = [];

  var languages = [
    {lang.en: 'Mon', lang.es: 'Lun', lang.pt: 'Seg'}, // monday
    {lang.en: 'Tue', lang.es: 'Mar', lang.pt: 'Ter'}, // tuesday
    {lang.en: 'Wen', lang.es: 'Mie', lang.pt: 'Qua'}, // wednesday
    {lang.en: 'Thu', lang.es: 'Jue', lang.pt: 'Qui'}, // thursday
    {lang.en: 'Fri', lang.es: 'Vie', lang.pt: 'Sex'}, // friday
    {lang.en: 'Sat', lang.es: 'Sab', lang.pt: 'Sab'}, // thursday
    {lang.en: 'Sun', lang.es: 'Dom', lang.pt: 'Dom'} // saturday
  ];
  @override
  void initState() {
    super.initState();
    if (this.widget.initialValue != null)
      daysSelected = this.widget.initialValue;

    // create all DisplayDays
    this.widget.displayDays.forEach((day) {
      displayedDays.add(_DayItem(
        borderSide: this.widget.borderSide,
        onTap: _dayTap,
        label: languages[day.index][widget.language],
        value: day,
        fillColor: widget.fillColor,
        selectedFillColor: this.widget.selectedFillColor,
        textStyle: this.widget.textStyle,
        highlightColor: this.widget.highlightColor,
        splashColor: this.widget.splashColor,
        borderRadius: this.widget.borderRadius,
        elevation: this.widget.elevation,
        selected: widget.initialValue == null
            ? false
            : widget.initialValue
                        .firstWhere((d) => day == d, orElse: () => null) ==
                    null
                ? false
                : true,
      ));
    });
  }

  _dayTap(days day) {
    if (daysSelected.contains(day)) {
      daysSelected.remove(day);
    } else {
      daysSelected.add(day);
    }
    if (widget.onChange != null) {
      widget.onChange(daysSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<days>>(
      enabled: this.widget.enabled,
      initialValue: widget.initialValue,
      autovalidate: widget.autovalidate,
      onSaved: (days) {
        if (widget.onSaved != null) widget.onSaved(days);
      },
      validator: (days) {
        if (widget.validator != null) return widget.validator(days);
        return null;
      },
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisAlignment: widget.mainAxisAlignment,
              mainAxisSize: widget.mainAxisSize,
              children: displayedDays,
            ),
            state.hasError
                ? Text(state.errorText,
                    style: this.widget.errorTextStyle)
                : Container()
          ],
        );
      },
    );
  }
}

class _DayItem extends StatefulWidget {
  _DayItem(
      {Key key,
      this.fillColor,
      this.selectedFillColor = Colors.red,
      this.label,
      this.onTap,
      this.value,
      this.textStyle,
      this.borderSide,
      this.highlightColor,
      this.splashColor,
      this.selected = false,
      this.borderRadius,
      this.elevation})
      : super(key: key);
  final selected;
  final Color fillColor;
  final Color selectedFillColor;
  final Function(days) onTap;
  final String label;
  final days value;
  final TextStyle textStyle;
  final BorderSide borderSide;
  final Color splashColor;
  final Color highlightColor;
  final double borderRadius;
  final double elevation;

  __DayItemState createState() => __DayItemState();
}

class __DayItemState extends State<_DayItem> {
  bool selected;

  @override
  void initState() {
    // TODO: implement initState
    selected = this.widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);

    return RawMaterialButton(
        onPressed: () {
          if (widget.onTap != null) {
            widget.onTap(widget.value);
          }
          setState(() {
            selected = !selected;
          });
        },
        focusColor: widget.selectedFillColor,
        highlightColor: Colors.yellow,
        splashColor: this.widget.splashColor,
        elevation: this.widget.elevation,
        constraints: BoxConstraints(minWidth: 40, minHeight: 40),
        fillColor: selected == true
            ? widget.selectedFillColor ?? buttonTheme.colorScheme.background
            : widget.fillColor ?? buttonTheme.colorScheme.background,
        textStyle: widget.textStyle ??
            Theme.of(context)
                .textTheme
                .button, //if not textstyle sended, textTheme.button by default
        child: Text(widget.label),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: selected ? widget.borderSide : BorderSide.none));
  }
}

enum days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }
enum lang { en, es, pt }
