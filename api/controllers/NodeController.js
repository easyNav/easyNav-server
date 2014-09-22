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
			res.json(nodes);
		});
	},


	summary: function(req, res) {
		Node.find().exec(function(err, nodes) {
			if (nodes.length === 0)
				return res.json({})
			result = _.map(nodes, 
				function(node) {
					return {
						name: node.name, 
						id: node.id,
						SUID: node.SUID
					}
				});

			res.json(result);
		});
	}



};

