import 'package:flutter/material.dart';
//import 'dart:math';

class FitCustomWeightChart extends CustomPainter{
  
  
  Color color;
  double textScaleFactoryXAxis = 1.0;
  double textScaleFactoryYAxis = 1.2;
  double maxValueData;
  TextStyle textStyle;
  BuildContext context;
  int currentValue;
  
  List<double> data = [];
  List<String> labels = [];
  double bottomPadding = 0.0;
  double leftPadding = 0.0;

  static const double barRadius = 2;




  FitCustomWeightChart({
    @required this.data,
    @required this.labels,
    @required this.maxValueData,
    this.currentValue,
    this.color = Colors.lightGreenAccent,
    this.textStyle,
    @required this.context});


  @override
  void paint(Canvas canvas, Size size) {

    setTextPadding(size);


    
    List<Offset> coordinates = getCoordinates(size);

  //  drawDashedLines(canvas, size, 0 + leftPadding, size.height/size.height + 5,Colors.grey[100]);
  //  drawDashedLines(canvas, size, 0 + leftPadding, size.height/5 + 5,Colors.grey[100]);
  //  drawDashedLines(canvas, size, 0 + leftPadding, size.height/2.5 + 5,Colors.grey[100]);
  //  drawDashedLines(canvas, size, 0 + leftPadding, size.height/1.7 + 5,Colors.grey[100]);
    drawXLabels(canvas,size,coordinates);
    drawYLabels(canvas,size,coordinates);
    drawBackgroundBar(canvas,size,coordinates);
    drawBar(canvas,size,coordinates);
   // drawLines(canvas,size,coordinates);
  }

  @override
  bool shouldRepaint(FitCustomWeightChart old) {
    return old.data != data && FitCustomWeightChart != FitCustomWeightChart;
  }

  void setTextPadding(Size size) {
    bottomPadding = size.height / 6;
    leftPadding = size.width / 10;
  }

  List<Offset> getCoordinates(Size size) {

    List<Offset> coordinates = [];

    //double maxData = data.reduce(max);
    double maxData = maxValueData;

    double width = size.width - leftPadding;
    double minBarWidth = width / data.length;

    for (var index = 0; index < data.length; index++) {

      double left = minBarWidth * index + leftPadding;

      double normalized = data[index] / maxData;
      double height = size.height - bottomPadding;
      double top = height - normalized * height;

      Offset offset = Offset(left, top);
      coordinates.add(offset);
    }

    return coordinates;
  }

  void drawBar(Canvas canvas, Size size, List<Offset> coordinates) {


    var multiply;

    if(coordinates.length > 12){
      multiply = 0.01;
    }
    else
    {
      multiply = 0.014;
    }

    Paint paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

    for(var index = 0 ; index < coordinates.length;index++){

       double barWidthMargin = (size.width * multiply);

       Offset offset = coordinates[index];
       double left = offset.dx - barWidthMargin;
       double right = offset.dx + barWidthMargin;
       double top = offset.dy;
       double bottom = size.height - bottomPadding;

       Path path = Path();



       path.addRRect(
          // RRect.fromRectAndRadius(Rect.fromLTRB(left, top, right, bottom), Radius.elliptical(15, 15))
         RRect.fromRectAndCorners(Rect.fromLTRB(left, top, right, bottom),
             topLeft: Radius.circular(barRadius),
             topRight: Radius.circular(barRadius) ,
             bottomRight:Radius.circular(barRadius),
             bottomLeft: Radius.circular(barRadius)
         ),
       );
       // canvas.drawRect(rect, paint);
       canvas.drawPath(path, paint);

      
    }
  }

  void drawBackgroundBar(Canvas canvas, Size size, List<Offset> coordinates) {

    var multiply;

    if(coordinates.length > 12){
      multiply = 0.01;
    }
    else
    {
      multiply = 0.014;
    }

    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for(var index = 0 ; index < coordinates.length;index++){

      double barWidthMargin = (size.width * multiply);

      Offset offset = coordinates[index];
      double left = offset.dx - barWidthMargin;
      double right = offset.dx + barWidthMargin;
      double top =  size.height / size.height;
      double bottom = size.height - bottomPadding;

      Path path = Path();



      path.addRRect(
        // RRect.fromRectAndRadius(Rect.fromLTRB(left, top, right, bottom), Radius.elliptical(15, 15))
        RRect.fromRectAndCorners(Rect.fromLTRB(left, top, right, bottom),
            topLeft: Radius.circular(barRadius),
            topRight: Radius.circular(barRadius) ,
            bottomRight:Radius.circular(barRadius),
            bottomLeft: Radius.circular(barRadius)
        ),
      );
      // canvas.drawRect(rect, paint);
      canvas.drawPath(path, paint);


    }
  }

  void drawXLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    for(int index = 0 ; index < labels.length;index++){

      if(labels.length > 12){

         if(index % 4 == 0){
           TextSpan span = TextSpan(
               style: textStyle.copyWith(
                 textBaseline: TextBaseline.alphabetic,
                 color: currentValue == (index + 1)  ? color :  textStyle.color,
                 fontWeight: currentValue == (index + 1)  ? FontWeight.bold :  textStyle.fontWeight,
               ),
               text: labels[index]);

           TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
           textPainter.layout();

           Offset offset = coordinates[index];
           double dx = offset.dx - textPainter.size.width * 0.5;
           double dy = size.height - textPainter.height;

           textPainter.paint(canvas, Offset(dx,dy));
         }

      }

      else if(labels.length <= 12){
        TextSpan span = TextSpan(
            style: textStyle.copyWith(
              textBaseline: TextBaseline.alphabetic,
              color: currentValue == (index + 1)  ? color :  textStyle.color,
              fontWeight: currentValue == (index + 1)  ? FontWeight.bold :  textStyle.fontWeight,
            ),
            text: labels[index]);

        TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
        textPainter.layout();

        Offset offset = coordinates[index];
        double dx = offset.dx - textPainter.size.width * 0.5;
        double dy = size.height - textPainter.height;

        textPainter.paint(canvas, Offset(dx,dy));
      }

    }

  }

  double calculateFontSize(String label, Size size, {bool xAxis}) {
    int numberOfCharacters = label.length;
    
    double fontSize = (size.width / numberOfCharacters) / data.length;
    
    if(xAxis){
      fontSize *= textScaleFactoryXAxis;
    }
    else {
      fontSize *= textScaleFactoryYAxis;
    }
    
    return fontSize;
    
  }

  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double bottomY = coordinates[0].dy;
    double topY = coordinates[0].dy;
    int indexOfMax = 0;
    int indexOfMin = 0;
    
    for(int index = 0 ; index < coordinates.length; index++){
      double dy = coordinates[index].dy ;
      
      if(bottomY < dy){
        bottomY  = dy;
        indexOfMin =  index;
      }
      
      
      if(topY > dy){
        topY = dy;
        indexOfMax = index;
      }
      
    }
    
    
    String maxValue = "${data[indexOfMax].toInt()}";
    String minValue = "${data[indexOfMin].toInt()}";
    
    double fontSize = calculateFontSize(maxValueData.round().toString(), size,xAxis: true);


    
    drawYText(canvas,maxValueData.round().toString(),fontSize,0);
    drawYText(canvas,(maxValueData.round() * 0.5).round().toString(), fontSize, (size.height - bottomPadding -(fontSize*0.5)) * 0.5);
    drawYText(canvas,(maxValueData.round() * 0.75).round().toString(), fontSize,  (size.height - bottomPadding - (fontSize*0.5)) * 0.25);
    drawYText(canvas,(maxValueData.round() * 0.25).round().toString(), fontSize,  (size.height - bottomPadding - (fontSize*0.5)) * 0.75);
    drawYText(canvas, "0", fontSize, size.height - bottomPadding-(fontSize*0.5));


    if(data[indexOfMax] != 0){
      drawYTextTop(canvas,maxValue,fontSize,topY - fontSize/3,Colors.red);
      drawDashedLines(canvas, size, 0  + leftPadding, topY,Colors.red);
    }


    if(data[indexOfMin] != 0){
      drawYTextTop(canvas,minValue,fontSize,bottomY,Colors.lightGreen);
      drawDashedLines(canvas, size, 0  + leftPadding, bottomY,Colors.lightGreenAccent);
    }

    
  }

  void drawLines(Canvas canvas, Size size, List<Offset> coordinates) {

    Paint paint = Paint()
        ..color = color.withOpacity(0.3)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth  = 3.0;

    double bottom = size.height - bottomPadding;
    double left = coordinates[0].dx * 0.7;
    
    
    Path path = Path();
    path.moveTo(left, bottom);
    path.lineTo(size.width, bottom);

   // canvas.drawPath(path, paint);

    
  }

  void drawYText(Canvas canvas, String value, double fontSize, double topY) {
    
    TextSpan span = TextSpan(
      style: textStyle,
      text: value
    );
    
    TextPainter textPainter = TextPainter(text: span,textDirection: TextDirection.rtl,textAlign: TextAlign.center);
    textPainter.layout();
    
    Offset offset = Offset(0.0, topY);
    
    textPainter.paint(canvas, offset);
    
  }

  void drawYTextTop(Canvas canvas, String value, double fontSize, double topY, Color color) {

    TextSpan span = TextSpan(
        style: textStyle.copyWith(
          color: color
        ),
        text: value
    );

    TextPainter textPainter = TextPainter(text: span,textDirection: TextDirection.rtl,textAlign: TextAlign.center);
    textPainter.layout();

    Offset offset = Offset(0.0 + 20, topY - 10);

    textPainter.paint(canvas, offset);

  }


  void drawDashedLines(Canvas canvas,Size size,double x,double y,Color color){
    
    var paint = Paint()
      ..color = color.withOpacity(0.9)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    var max = size.width - leftPadding - (size.width * 0.05);
    var dashWidth = 5;
    var dashSpace = 8;
    while (max >= 0) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth,y), paint);
      final space = (dashSpace + dashWidth);
      x += space;
      max -= space;
    }

  }
}