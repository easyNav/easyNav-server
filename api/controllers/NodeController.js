/**
 * NodeController
 *
 * @description :: Server-side logic for managing nodes
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

	// create: function(req, res) {
	// 	var name = req.param('name');
	// 	Node.findOne('name')

	// 	res.send(id);
	// }

	deleteAll: function(req, res) {
		Node.destroy({}).exec(function(err, nodes) {
			res.json((nodes));
		});
	}

};

