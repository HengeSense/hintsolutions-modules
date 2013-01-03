var module = require('ru.hintsolutions.stackmob');

// Connection to StackMob
module.connect(
	{
		version : 0, // API version
		publicKey : "YOUR PUBLIC KEY" // Public key
	}
);

// Request query
module.reguestQuery(
	{
		schema : "YOUR SCHEMA NAME", // StackMob Schema
		/*
		headers : { // HTTP Request header
		},
		params : { // HTTP Request params
		},
		sorting : {
			filed : "name", // Sorting field name
			asc : true // Is ascending sorting
		},
		padding : {
			from : 0, // Start index in response
			to : 10 // End index in response
		},
		limit : {
			count : 100 // Count of response
		}
		*/
		success : function(responseArray) // Success callback
		{
			alert(responseArray);
		},
		failure : function(error) // Failure callback
		{
			alert(error);
		}
	}
);

// Request custom code
module.reguestCustomCode(
	{
		method : "YOUR METHOD NAME", // Method name
		/*
		verb : "GET", // HTTP Verb POST | PUT | GET | DELETE
		params : { // HTTP request params
		},
		body : "" // HTTP request body
		*/
		success : function(responseJSON) // Success callback
		{
			alert(responseJSON);
		},
		failure : function(error) // Failure callback
		{
			alert(error);
		}
	}
);

// Disconnect to StackMob
module.disconnect();
