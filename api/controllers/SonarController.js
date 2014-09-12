/**
 * SonarController
 *
 * @description :: Server-side logic for managing sonars
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	deleteAll: function(req, res) {
		Sonar.destroy({}).exec(function(err, sonars) {
			res.json(sonars);
		});
	}
};

