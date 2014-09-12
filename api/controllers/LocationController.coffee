###
LocationController

@description :: Server-side logic for managing location
@help        :: See http://links.sailsjs.org/docs/controllers
###

module.exports = update: (req, res) ->
  LocationService.update({
    x: req.param('x'),
    y: req.param('y'),
    z: req.param('z')
  }, (err, person) ->
    res.serverError(err) if err
    res.json(person)
  )

, retrieve: (req, res) ->
  LocationService.retrieve (err, person) ->
    res.serverError(err) if err
    res.json(person)
