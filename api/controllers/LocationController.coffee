###
LocationController

@description :: Server-side logic for managing location
@help        :: See http://links.sailsjs.org/docs/controllers
###

module.exports = update: (req, res) ->

  async.waterfall [
    (cb) -> 
      LocationService.retrieve (err, person) ->
        cb(err) if err
        cb null, person


    (person, cb) ->
      if (!req.param('orientation'))
        sails.log('GOT A NULL FOR ORIENTATION')

      LocationService.update({
        x: req.param('x'),
        y: req.param('y'),
        z: req.param('z'),
        orientation: req.param('orientation') || person.orientation

      }, (err, updatedPerson) ->
        cb(err) if err 
        cb err, updatedPerson
      )
      
  ], (err, updatedPerson) ->
    res.serverError(err) if err
    res.json(updatedPerson)



, retrieve: (req, res) ->
  LocationService.retrieve (err, person) ->
    res.serverError(err) if err
    res.json(person)
