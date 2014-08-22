/**
* Edge.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

 var async = require('async');

module.exports = {

  attributes: {
  	name: {
  		type: 'string'
  	},

    SUID: {
      type: 'string', 
      required: true,
      unique: true
    },

    source: {
    	type: 'string', 
    	required: true
    },

    target: {
    	type: 'string', 
    	required: true 
    },

    sourceColor: {
    	type:'string', 
    	required: true
    },

    targetColor: {
    	type:'string', 
    	required: true
    }

  },

  beforeCreate: function(edge, callback) {

    async.series({
      source: function(cb) {
        Node.findOne({ SUID: edge.source }).exec( function(err, source) {
          if (!source) return cb({error: 'source not found'});
          cb(null, source);
        });
      },

      target: function(cb) {
        Node.findOne({ SUID: edge.target }).exec( function(err, target) {
          if (!target) return cb({error: 'target not found'});
          cb(null, target);
        });
      }
    },

    function(err, results) {
      if (err) return callback(err);
      
      callback(null, edge);
    });
  }
};

