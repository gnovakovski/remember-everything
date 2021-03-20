
class Folder{
  final int id;
  final String name;
  final int createDate;
  final int updateDate;

  Folder({this.id,this.name, this.createDate, this.updateDate});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "name" : name,
      "createDate" : createDate,
      "updateDate" : updateDate
    };
  }
}