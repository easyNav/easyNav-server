###*
MapService

@description :: Server-side logic for managing maps
@help        :: See http://links.sailsjs.org/docs/controllers
###

async = require 'async'

module.exports = retrieve: (callback) ->
  LocationService.retrieve (err, loc) ->
    callback(err) if err
    SonarService.retrieveAll (err, sonars) ->
      callback(err) if err
      callback(null, {
        location: loc, 
        sonars: sonars
      });



