
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("sendpush", function(request, response) {
  // Creates a pointer to _User with object id of userId
	var targetUser = new Parse.User();
	targetUser.id = request.params.user;

	var query = new Parse.Query(Parse.Installation);
	query.equalTo('user', targetUser);
	Parse.Push.send({
        where: query,
        data: {
            alert: "One of your sneeks was matched by " + request.params.username
        }
    }, {
    success: function() {
        response.success();
        console.log("success: Parse.Push.send did send push");
    },
    error: function(e) {
        response.error(err);
        console.log("error: Parse.Push.send code: " + e.code + " msg: " + e.message);
    }
    });
});
