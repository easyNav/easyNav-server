/**
 * MapController
 *
 * @description :: Server-side logic for managing maps
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	


  /**
   * `MapController.show()`
   */
  show: function (req, res) {

    var wrapWithData = function(target) {
      return { data: target };
    }

    Node.find({}).exec( function(err, nodes) {
	    Edge.find({}).exec( function(err, edges) {
	    	if (err) return res.json(400, { err: err } );

	    	return res.json({
          nodes: _.map(nodes, wrapWithData, ''),
	    		edges: _.map(edges, wrapWithData, '')
	    	});
	    });
	});
  },

  update: function(req, res) {
  	return res.json({msg: 'to implement!!'});
  },

  getShortestPath: function(req, res) {
  	return res.json({msg: 'to implement!!'});
  }
};

