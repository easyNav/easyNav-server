/**
* Node.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {
  attributes: {
  	name: {
  		type: 'string',
  		required: true,
  		unique: true
  	}
  },

  beforeValidate: function(node, cb) {
  	Node.findOne(node.name).exec(function(err, theNode) {
  		if (err) return cb(err);
  		if (theNode) return cb(new Error('Node exists.'));
  		cb(null, node);
  	});
  }
};

