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

        var nodeResult = _.map(nodes, wrapWithData, '')
          , edgesResult = _.map(edges, wrapWithData, '');

	    	return res.json({

          // TODO: Apparently, ID is used instead of SUID for cytoscape JS.  So SUID is swapped for ID.
          //TODO: Clean up the remapping code below -------------------
          nodes: _.forEach(nodeResult, function(node) {
            node.data.id = node.data.SUID;
            delete node.data.SUID;

            node.data.loc = JSON.parse(node.data.loc);
            node.position = {
              x: parseFloat(node.data.loc.x),
              y: parseFloat(node.data.loc.y),
              z: parseFloat(node.data.loc.z)
            };
            delete node.data.loc;
            node.locked = true;

          }),
	    		edges: _.forEach(edgesResult, function(edge) {
            edge.data.id = edge.data.SUID;
            delete edge.data.SUID;


          })

	    	});
	    });
	});
  },


  update: function(req, res) {
    //TODO: Refactor and move this conversion function out of space
    var nusToCytoscape = function(input, cbDone) {

      // iterator fn used for _.map
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

      // iterator fn used for _.map
      var remapEdges = function(target, idx) {
        var edgesList = [], i = 0, u = 0;
        var destList = target.linkTo.replace(/ /g,'').split(',');
        for (i = 0; i < destList.length; i++) {
          edgesList.push({
            name: 'edge', 
            SUID: 'idx' + idx + 'e' + u.toString(),
            source: target.nodeId, 
            target: destList[i],
            interaction: 'undirected', 
            shared_interaction: 'undirected'
          });
          u++;
        }
        return edgesList;
      };


      // actual process goes here
      var mapObj = {
        nodes: _.map(input.map, remapNodes),
        edges: _.flatten(_.map(input.map), remapEdges)
      };

      async.series({
        createNodes: function(cb) {
          Node.saveMany(mapObj.nodes, function(err) {
            cb(err);
          });
        },
        createEdges: function(cb) {
          Edge.saveMany(mapObj.edges, function(err) {
            cb(err);
          });
        }
      },
      function(err) {
        return cbDone(err, mapObj);
      });
    };


    // Do actual request here
    request
      .get('http://showmyway.comp.nus.edu.sg/getMapInfo.php?Building=DemoBuilding&Level=1')
      .end(function(nusRes) {
        nusToCytoscape(JSON.parse(nusRes.text), function(err, obj) {
          if (err) return res.serverError(err);
          return res.json(obj);
        });
      });
  },

  getShortestPath: function(req, res) {
  	return res.json({msg: 'to implement!!'});
  }
};

