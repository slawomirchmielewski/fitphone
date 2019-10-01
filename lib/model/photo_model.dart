class PhotoModel{

  String url;
  int date;
  String name;
  String id;
  String folder;
  String path;


  PhotoModel({
    this.url,
    this.date,
    this.name,
    this.id,
    this.folder,
    this.path,
  });

  factory PhotoModel.fromMap(Map<dynamic,dynamic> map){
    return PhotoModel(
      url: map['url'],
      date: map["date"],
      name: map["name"],
      folder: map["folder"],
      path: map["path"],
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "url" : url,
      "date" : DateTime.now().millisecondsSinceEpoch,
      "name" : name ?? "New photo",
      "folder" : "",
      "path" : path
    };

    return map;
  }
}