var http=require('http');


var mongo = require('mongodb'),
Server = mongo.Server,
Db = mongo.Db,
ObjectID = require('mongodb').ObjectID;
var request = require('request');
//Importing the required mongodb driver
var mongoClient = require('mongodb').MongoClient;
const newsApiUrl='https://newsapi.org/v1/articles?source=';
//MongoDB connection URL
var dbHost = 'mongodb://serviceaccount:serviceaccount@ds157325.mlab.com:57325/news-data';
const sources=['usa-today','cnn','time','the-times-of-india','the-telegraph','the-hindu',
'reuters','mirror','metro'];

sources.forEach(function newsSources(source) {
  mongoClient.connect(dbHost,function (err,db) {
    console.log(source);
    db.collection(source).createIndex( {'uniqueId':1}, { unique: true } );

  })
})

sources.forEach(function newsSources(source) {
  var urlCnn=newsApiUrl+source+'&sortBy=latest&apiKey=cfa4042e7b5e4d7c8582a24d8d8f31ca';
  var requestLoop = setInterval(function(){
    request(urlCnn, function (error, response, body) {
      if (!error && response.statusCode == 200) {
        mongoClient.connect(dbHost,function(err,db){
          var res=JSON.parse(response.body);
          if(err) throw err;
          res.articles.forEach(function(value){
            var uniqueId=value.publishedAt+value.title;
            value.uniqueId=uniqueId;
            value.createdAt=new Date();
            result=db.collection(source).insertOne(value, function (err, results) {
              if (err) {
                console.log('already exists ');
              };
            });
          });
        });
      }
    })
  }, 60000);
  requestLoop;

});
