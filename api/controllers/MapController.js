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
    MapService.populateMap(req.param('building'), req.param('floor'), function(err, data) {
      if (err) res.serverError(err);
      res.json(200, data);
    });
  },


  destroy: function(req, res) {
    MapService.destroy(function(err, data) {
      if (err) res.serverError(err);
      res.json(200, {result: 'cleared map'});
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
  },


  goto: function(req, res) {
    MapService.goto(req.param('to'), function(err, data) {
      if (err) res.serverError(err);
      res.json(200, data);
    });
  }
};

