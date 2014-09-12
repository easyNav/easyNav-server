###*
MapService

@description :: Server-side logic for managing maps
@help        :: See http://links.sailsjs.org/docs/controllers
###

request = require 'superagent'
async = require 'async'
cytoscape = require 'cytoscape'

module.exports = update: (opts, callback) ->
  LocationService.exists (err, found) ->
    callback(err) if (err)

    ## Create new person entry if nonexistent
    if (!found)
      Node.create({
        name: 'person',
        SUID: '-1',
        loc: {
          x: parseFloat(opts.x),
          y: parseFloat(opts.y),
          z: parseFloat(opts.z)
        }
      }).exec (err, person) ->
       callback(err, person)

    else 
      Node.update( {name: 'person'}, { 
        name: 'person',
        SUID: '-1',
        loc: {
          x: opts.x,
          y: opts.y,
          z: opts.z
        }
      }).exec (err, person) ->
        callback(err, person)


, retrieve: (callback) ->
  LocationService.exists (err, found) ->
    callback(err) if (err)

    ## Create and return new person entry if nonexistent
    if (!found)
      Node.create({
        name: 'person',
        SUID: '-1',
        loc: {
          x: parseFloat('0'),
          y: parseFloat('0'),
          z: parseFloat('0')
        }
      }).exec (err, person) ->
        callback(err, person)

    ## Else return the person
    else 
      Node.findOne({ name: 'person' }).exec (err, person) ->
        callback(err, person)


, exists: (callback) ->
  Node.findOne({ SUID : '-1' }).exec (err, person) ->
    callback(err) if err
    callback(null, person) 


