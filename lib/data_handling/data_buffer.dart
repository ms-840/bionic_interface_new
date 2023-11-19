class DataBuffer{
  //should be used to ensure data transmission can be consistent even if the processing and sending rates are different
  // primarily to be used for communications with the APP


  //i am not sure if the spirit of the implementation is the same, as normally what you would be moving is pointers to data rather than the data itself
  // the database also somewhat works as a backup
  //TODO: change this from a list into a listqueue -> https://api.flutter.dev/flutter/dart-collection/ListQueue-class.html
  final buffer = []; // no set type of item, so anything can be added
  final int maxBufferSize;
  final double targetFillPercentage;
  bool initialFillingComplete = false;

  DataBuffer({this.maxBufferSize = 200, this.targetFillPercentage = 0.5}); //the defaults here are completely random at he moment

  void checkInitialFillingStatus(){
    """ Checks if conditions are met to start emptying buffer""";
    if (!initialFillingComplete && buffer.length>(maxBufferSize*targetFillPercentage)){
      initialFillingComplete = true;
      // this can now be used to start passing data on to wherever it needs to go
    }
  }

  void addToBuffer(var data){
    buffer.add(data);
    checkInitialFillingStatus(); //to ensure the data
  }

  dynamic removeFromBuffer(){
    """ Remove and return the first item from the buffer """;
    var removedItem = buffer[0];
    buffer.removeAt(0);
    return removedItem;
  }

  void moveItemToOtherBuffer(DataBuffer secondaryBuffer){
    var removedItem = removeFromBuffer();
    secondaryBuffer.addToBuffer(removedItem);
  }

  dynamic removeMultipleFromBuffer(int length){
    var removedItems = buffer.sublist(0, length-1);
    buffer.removeRange(0, length-1);
    return removedItems;
  }

  void emptyBuffer(){
    buffer.clear();
  }

  int getBufferLength(){
    return buffer.length;
  }

}