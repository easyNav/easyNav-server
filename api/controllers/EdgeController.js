/**
 * EdgeController
 *
 * @description :: Server-side logic for managing Edges
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */


module.exports = {

	// deletes all edges
	deleteAll: function(req, res) {
		Edge.destroy({}).exec(function(err, edges) {
			res.json(edges);
		});
	},

	deleteBySuid: function(req, res) {
		Edge.destroy({SUID: req.param('SUID') }).exec( function(err, edge) {
			res.json(edge);
		});
	}



};

