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

    Node.find({}).exec( function(err, nodes) {
	    Edge.find({}).exec( function(err, edges) {
	    	if (err) return res.json(400, { err: err } );
	    	return res.json({
	    		nodes: nodes,
	    		edges: edges
	    	});
	    });
	});

  }
};

