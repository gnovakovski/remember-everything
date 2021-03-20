
class Note{
  final int id;
  final String title;
  final String content;
  final int folderId;
  final int createDate;
  final int updateDate;

  Note({this.id,this.title,this.content, this.folderId, this.createDate, this.updateDate});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "title" : title,
      "content" : content,
      "folderId" : folderId,
      "createDate" : createDate,
      "updateDate" : updateDate
    };
  }
}