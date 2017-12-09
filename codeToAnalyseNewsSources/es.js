var request = require("request");
var extractor = require('unfluff');
var newsPaper='http://newspaper-demo.herokuapp.com/articles/show?url_to_clean=';
var parseMyAwesomeHtml = function(html) {
  console.log(html);
      data = extractor(html);
      // /console.log(data);

};
request(newsPaper+'http://www.cnn.com/2017/12/06/politics/jerusalem-peace-process-white-house/index.html', function (error, response, body) {
    if (!error) {
        parseMyAwesomeHtml(body);
    } else {
        console.log(error);
    }
});
