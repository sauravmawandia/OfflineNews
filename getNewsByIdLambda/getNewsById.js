
//api to get news by id
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

client.search({
  index: 'cnn',
  type: 'news',
  body: {
    query: {
      ids : {
        values : [event.id]
      }
    }
  }

}).then(function (resp) {
  var hits = resp.hits.hits[0 ];
  var response={};
  response.text=hits._source.Text;
  response.publishedAt=hits._source.publishedAt;
  response.id=hits._id;
  response.imageURL=hits._source.imageURL;
  response.title=hits._source.title;
  response.author=hits._source.author;
  response.description=hits._source.description;
  console.log(response);
  callback(null,response);
}, function (err) {
  console.trace(err.message);
  callback(err,null);
});
}
