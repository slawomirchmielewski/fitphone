import 'package:fitphone/view/embaded_view/video_view.dart';
import 'package:flutter/material.dart';


class FitExerciseListTile extends StatelessWidget {

  final int id;
  final String exerciseName;
  final String sets;
  final String reps;
  final String imageUrl;
  final String rest;


  FitExerciseListTile({
    this.id,
    this.exerciseName,
    this.sets,
    this.reps,
    this.rest,
    this.imageUrl
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8),
      child: Material(
        color: Theme.of(context).primaryColorLight,
        shadowColor: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: InkWell(
          enableFeedback: true,
          excludeFromSemantics: true,
         // onTap: (){},
          child: Container(
            margin: EdgeInsets.all(8),
            height: 80,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16,right: 8),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        child: Text("$id",style: Theme.of(context).textTheme.headline.copyWith(
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(exerciseName,style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Reps: $reps"),
                              SizedBox(width: 8),
                              Text("Sets: $sets"),
                              SizedBox(width: 8),
                              Text("Rest: $rest"),
                              Text("min",style: Theme.of(context).textTheme.subtitle.copyWith(
                                fontSize: 10),

                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(icon: Icon(Icons.play_circle_outline), onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoView(imageUrl,exerciseName)));
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
