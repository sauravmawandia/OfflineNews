//apiu
exports.handler = (event, context, callback) => {
  var AWS = require('aws-sdk');
  var elasticsearch=require('elasticsearch');
  var httpAws= require('http-aws-es');
  AWS.config.update({
    accessKeyId: process.env.accessKeyId,
    secretAccessKey:process.env.secretAccessKey,
    region:process.env.region
    });
  //create a elasticsearch client
  var client = new elasticsearch.Client({
    host: process.env.elasticsearchUrl,
    connectionClass:httpAws,
  });

  var allRecords = [];
  var myDate = new Date();
  myDate.setMinutes(myDate.getMinutes()-process.env.lastNMinutes);
  client.search({
    index: 'cnn',
    type: 'news',
    scroll: '10s',
    _source :['title','publishedAt','imageURL','description'],
    body: {
      query:{
        bool:{
          filter:{
            range:{
              publishedAt :{
                gte:Date.parse(myDate)
              }
            }
          }
        }
      }
    }
  },function getMoreUntilDone(error, response) {
    if(error){
      callback(error,null);
      console.log(error);
    } else {
      // collect all the records
      response.hits.hits.forEach(function (hit) {
        allRecords.push(hit);
      });
      if (response.hits.total !== allRecords.length) {
        // now we can call scroll over and over
        client.scroll({
          scrollId: response._scroll_id,
          scroll: '10s'
        }, getMoreUntilDone);
      } else {
        var arr=[];
        for (var i = 0, len = allRecords.length; i < len; i++) {
          var response={};
          response.title=allRecords[i]._source.title;
          response.publishedAt=allRecords[i]._source.publishedAt;
          response.id=allRecords[i]._id;
          response.imageURL=allRecords[i]._source.imageURL;
          response.description=allRecords[i]._source.description;
          if(!(response.title==null||response.publishedAt==null||response.id==null||response.description==null)){
              arr.push(response);
          }
        }
        var nw={news:arr};
        console.log(nw);
        callback(null,nw);
      }
    }
  });
}
