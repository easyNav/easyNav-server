###*
Heartbeat semaphore controller

@description :: Server-side logic for managing sonars
@help        :: See http://links.sailsjs.org/docs/controllers
###
module.exports = view: (req, res) ->
  HeartbeatSemaphoreService.view (err, sm) ->
    res.json(err) if err
    res.json sm


, update: (req, res) ->
  opts = {
    x: String(req.param('x')),
    y: String(req.param('y')),
    val: String(req.param('val'))
  }
  HeartbeatSemaphoreService.update opts, (err, sm) ->
    res.json(err) if err
    sails.log sm
    res.json sm



