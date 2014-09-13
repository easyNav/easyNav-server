###*
SonarController

@description :: Server-side logic for managing sonars
@help        :: See http://links.sailsjs.org/docs/controllers
###
module.exports = deleteAll: (req, res) ->
  Sonar.destroy({}).exec (err, sonars) ->
    res.json sonars


, update: (req, res) ->
  SonarService.update({
    name: req.param('name'),
    distance: req.param('distance')

  }, (err, sonar) ->
    res.serverError(err) if err
    res.json(sonar)
  )


, retrieve: (req, res) ->
  SonarService.retrieve({
    name: req.param('name')

  }, (err, sonar) ->
    res.serverError(err) if err
    res.json(sonar)
  )


, retrieveAll: (req, res) ->
  SonarService.retrieveAll (err, sonars) ->
    res.serverError(err) if err 
    res.json(sonars)


