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

    var nusToCytoscape = function(input, cb) {

      var remapNodes = function(target) {
        return {
          name: target.nodeName,
          SUID: target.nodeId,
          loc: {
            x: target.x,
            y: target.y,
            z: 0
          }
        };
      }


      var remapEdges = function(target) {
        var edgesList = [], i;
        var destList = target.linkTo.split(',');
        for (i = 0; i < target.linkTo.destList; i++) {
          edgesList.push({
            name: '', 
            SUID: '',                   // todo
            source: target.nodeId, 
            target: destList[i],
            interaction: 'undirected', 
            shared_interaction: 'undirected'
          });
        }
        return edgesList;
      };

    };

    request
      .get('http://showmyway.comp.nus.edu.sg/getMapInfo.php?Building=DemoBuilding&Level=1')
      .end(function(nusRes) {
        return res.json(JSON.parse(nusRes.text));
        // sails.log (JSON.parse(res.text));
      } );

      // sails.log (JSON.parse(res.text));

  	// return res.json({msg: 'to implement!!'});
  },

  getShortestPath: function(req, res) {
  	return res.json({msg: 'to implement!!'});
  }
};

