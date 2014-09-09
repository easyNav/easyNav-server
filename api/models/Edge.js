/**
* Edge.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

 var async = require('async');

module.exports = {

  tableName: 'edges', 

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

    weight: {
      type: 'float'
    },

    interaction: {
      type: 'string'
    },

    shared_interaction: {
      type: 'string'
    }
    
  },

  beforeCreate: function(edge, callback) {

    if (edge.source == edge.target) {
      callback({error: 'Edge controller - duplicate nodes!'});
    }

    edge.interaction = 'undirected';
    edge.shared_interaction = 'undirected';

    async.series({

      source: function(cb) {
        Node.findOne({ SUID: edge.source }).exec( function(err, source) {
          if (!source) return cb({error: 'Edge controller - source not found'});
          cb(null, source);
        });
      },

      target: function(cb) {
        Node.findOne({ SUID: edge.target }).exec( function(err, target) {
          if (!target) return cb({error: 'Edge controller - target not found'});
          cb(null, target);
        });
      },

      existentEdge: function(cb) {
        Edge.findOne({source: [edge.source, edge.target], 
                      target: [edge.source, edge.target] }).exec( function(err, sameEdge) {
          if (sameEdge) return cb({error: 'Edge controller - edge already exists'});
          cb(null);
        });
      }
    },

    function(err, results) {
      if (err) return callback(err);
      var source = results.source,
          target = results.target;

      // converting as MySQL treats nested JSON as string lol
      source.loc = JSON.parse(source.loc);
      target.loc = JSON.parse(target.loc);

      var x2 = Math.pow(source.loc.x - target.loc.x, 2);
      var y2 = Math.pow(source.loc.y - target.loc.y, 2);
      var z2 = Math.pow(source.loc.z - target.loc.z, 2);
      edge.weight = (Math.pow(x2 + y2 + z2, 0.5));
      callback(null, edge);
    });
  }
};

