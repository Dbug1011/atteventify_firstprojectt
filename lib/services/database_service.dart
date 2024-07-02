// const String EVENTS_COLLECTION_REF = 'events';
// // easy to reference the collection name
// class DatabaseService{

// final _firestore = FirebaseFirestore.instance;
// // reference of instance of firestore

// // late final CollectionReference_eventsRef;

// DatabaseService(){
//   _eventsRef=_firestore.collection(EVENTS_COLLECTION_REF).withConverter <Events>(fromFirestore:(snapshots,_)=>Events.fromJson(snapshots.data()!,) , toFirestore: (events,_)=>events.toJson(),);
// } 

// Stream<QuweySnapshot<Events>> getEvents(){
//   return _eventsRef.snapshots();

//   void addEvent(Events event) async{
//     _eventsRef.add(event);
//   }


// }