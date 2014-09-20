/**
* Node.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {
  tableName: 'nodes', 

  attributes: {
  	name: {
  		type: 'string',
  		required: true
  	},
    SUID: {
      type: 'string', 
      required: true,
      unique: true
    },

    loc: {
      type: 'json'
    },

    orientation: {
      type: 'string', 
      defaultsTo: '0'
    }
  },

  beforeValidate: function(node, cb) {

    // check if coordinates exist in node

    if (node.loc) {
    } else if (node.x &&  node.y && node.z) {
      node.loc = {
        x: parseFloat(node.x),
        y: parseFloat(node.y),
        z: parseFloat(node.z)
      }

      delete node.x;
      delete node.y;
      delete node.z;

    } else {
      return cb(new Error('No coordinates'));
    }


  	Node.findOne(node.SUID).exec(function(err, theNode) {
  		if (err) return cb(err);
  		if (theNode) return cb(new Error('Node exists.'));
      // successful
  		cb(null, node);
  	});
  },

  saveMany: function(nodes, cb) {
    async.each(nodes, 

    function(node, callback) {
      Node.create(node).exec(function (err, created) {
        callback(err);
      });
    },

    function(err) {
      if (err) return cb(new Error('failed to process nodes'));
      cb(); 
    });
  }
};

