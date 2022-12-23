class Message{
  late final String userId, messageContent, messageImage;
  late final int createdAt;
  
  Message(this.userId, this.messageContent, this.messageImage){
    createdAt = DateTime.now().millisecondsSinceEpoch;
  }
  factory Message.message(String userId, String message){
    return Message(userId, message, "");
  }
  factory Message.image(String userId, String imageUrl){
    return Message(userId, "", imageUrl);
  }
  Message.fromMap(Map<String, dynamic> model){
    userId = model["userId"];
    messageContent = model['message'];
    messageImage = model['image'];
    createdAt = model['createdAt'];
  }
  
  Map<String, dynamic> toMap(){
    return {
      "userId": userId,
      "message": messageContent,
      "image": messageImage,
      "createdAt": createdAt
    };
  }
}