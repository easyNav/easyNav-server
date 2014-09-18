/**
 * MapController
 *
 * @description :: Server-side logic for managing maps
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

 var request = require('superagent');

module.exports = {
	


  /**
   * `MapController.show()`
   */
  show: function (req, res) {
    MapService.showCyMap(function(err, data) {
      if (err) res.serverError(err);
      res.json(200, data);
    });
  },


  update: function(req, res) {
    MapService.populateMap(function(err, data) {
      if (err) res.serverError(err);
      res.json(200, data);
    });
  },

  getShortestPath: function(req, res) {
    MapService.shortestPath(req.param('from'), req.param('to'), function(err, data) {
      if (err) res.serverError(err);
      res.json(200, data);
    });
  },

  getNearestNode: function(req, res) {
    MapService.nearestNodeFromPos(function (err, data) {
      if (err) res.serverError(err);
      res.json(200, data);
    });
  }
};

