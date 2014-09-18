###*
MapService

@description :: Server-side logic for managing maps
@help        :: See http://links.sailsjs.org/docs/controllers
###

request = require 'superagent'
async = require 'async'
cytoscape = require 'cytoscape'

module.exports = showCyMap: (callback) ->
  wrapWithData = (target) ->
    data: target

  Node.find({}).exec (err, nodes) ->
    Edge.find({}).exec (err, edges) ->
      return callback(err)  if err
      nodeResult = _.map(nodes, wrapWithData, "")
      edgesResult = _.map(edges, wrapWithData, "")
      callback null,
        
        # TODO: Apparently, ID is used instead of SUID for cytoscape JS.  So SUID is swapped for ID.
        #TODO: Clean up the remapping code below -------------------
        nodes: _.forEach(nodeResult, (node) ->
          node.data.id = node.data.SUID
          delete node.data.SUID

          node.data.loc = JSON.parse(node.data.loc)
          node.position =
            x: parseFloat(node.data.loc.x)
            y: parseFloat(node.data.loc.y)
            z: parseFloat(node.data.loc.z)

          delete node.data.loc
          node.locked = true
          return
        )
        edges: _.forEach(edgesResult, (edge) ->
          edge.data.id = edge.data.SUID
          delete edge.data.SUID
          return
        )

, populateMap: (callback) ->
    #TODO: Refactor and move this conversion function out of space
    nusToCytoscape = (input, cbDone) ->
      
      # iterator fn used for _.map
      remapNodes = (target) ->
        name: target.nodeName
        SUID: target.nodeId
        loc:
          x: target.x
          y: target.y
          z: 0

      
      # iterator fn used for _.map
      remapEdges = (target, idx) ->
        edgesList = []
        i = 0
        u = 0
        destList = target.linkTo.replace(RegExp(" ", "g"), "").split(",")
        i = 0
        while i < destList.length
          edgesList.push
            name: "edge"
            SUID: "idx" + idx + "e" + u.toString()
            source: target.nodeId
            target: destList[i]
            interaction: "undirected"
            shared_interaction: "undirected"

          u++
          i++
        edgesList

      
      # actual process goes here
      mapObj =
        nodes: _.map(input.map, remapNodes)
        edges: _.flatten(_.map(input.map), remapEdges)

      async.series
        createNodes: (cb) ->
          Node.saveMany mapObj.nodes, (err) ->
            cb err
            return

          return

        createEdges: (cb) ->
          Edge.saveMany mapObj.edges, (err) ->
            cb err
            return

          return
      , (err) ->
        cbDone err, mapObj
      return

    # Do actual request here
    request.get("http://showmyway.comp.nus.edu.sg/getMapInfo.php?Building=COM1&Level=2").end (nusRes) ->
      nusToCytoscape JSON.parse(nusRes.text), (err, obj) ->
        return callback(err, obj)

, shortestPathNodeIds: (nodeFrom, nodeTo, callback) ->
    async.waterfall [
      (cb) ->
        MapService.showCyMap (err, result) ->
          cb(err) if err
          cy = cytoscape(
            elements: result
            ready: ->
              dijkstra = @elements().dijkstra('#' + nodeFrom, ->
                @data "weight"
              )
              path = dijkstra.pathTo(@$('#' + nodeTo))
              cb null, path.jsons()
          )
          return


      (elements, cb) ->
        nodes = _.map(_.where(elements,
          group: "nodes"
        ), (node) ->
          name: node.data.name
        )
        edges = _.map(_.where(elements,
          group: "edges"
        ), (edge) ->
          source: edge.data.source
          target: edge.data.target
        )
        pathList = []
        curNode = nodeFrom
        curEdge = {}
        nextNode = {}
        while edges.length > 0
          curEdge = _.find(edges,
            source: curNode
          )
          if curEdge
            _.remove edges,
              source: curNode

            nextNode = curEdge.target
          else
            curEdge = _.find(edges,
              target: curNode
            )
            _.remove edges,
              target: curNode

            nextNode = curEdge.source
          pathList.push curNode
          curNode = nextNode
        pathList.push curNode
        cb null, pathList

    ],

    (err, result) ->
      callback(err, result)

, shortestPath: (nodeFrom, nodeTo, callback) ->
  MapService.shortestPathNodeIds nodeFrom, nodeTo, (err, nodeIds) ->
    if err then callback(err)
    Node.find({ SUID : nodeIds }).exec (err, nodes) ->
      result = []
      for x in nodeIds 
        node = _.find(nodes, {SUID: x});
        result.push(node) if node
      callback(err, result)


, nearestNodeFromPos: (callback) ->
  async.parallel {
    person: (cb) ->
      LocationService.retrieve (err, person) ->
        cb(null, person)

    , nodes: (cb) ->
      Node.find({
        SUID: { '!' : -1}  
      }).exec (err, nodes) ->
        cb(null, nodes)

  },

  (err, results) ->
    result = {
      nearestNode: null
      nearestDist: null
    }
    a = results.person.loc
    a = JSON.parse(a) if (typeof a) is 'string'

    _.forEach results.nodes, (node) ->
      pow = Math.pow
      b = JSON.parse(node.loc)
      dist = Math.sqrt(pow(a.x - b.x, 2) 
        + pow(a.y - b.y, 2) 
        + pow(a.z - b.z, 2) )

      if (result.nearestDist is null) or (result.nearestDist > dist)
        result = {
          nearestNode: node
          nearestDist: dist
        }

    callback(err, result)


, destroy: (callback) ->
  Edge.destroy().exec (err, edges) ->
    Node.destroy().exec (err, nodes) ->
      callback(err, {edges: edges, nodes: nodes})


, goto: (nodeTo, callback) ->
  sails.log nodeTo
  MapService.nearestNodeFromPos (err, result) ->
    nodeFrom = result.nearestNode.SUID
    sails.log nodeFrom
    MapService.shortestPath nodeFrom, nodeTo,  (err, result) ->
      callback(err, result)



