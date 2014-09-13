###
HeartbeatController

@description :: Server-side logic for managing location
@help        :: See http://links.sailsjs.org/docs/controllers
###

module.exports = retrieve: (req, res) ->
  HeartbeatService.retrieve (err, heartbeat) ->
    res.serverError(err) if err
    res.json(heartbeat)
