###*
SonarService

@description :: Server-side logic for managing maps
@help        :: See http://links.sailsjs.org/docs/controllers
###

request = require 'superagent'
async = require 'async'
cytoscape = require 'cytoscape'

module.exports = update: (opts, callback) ->
  SonarService.exists opts.name, (err, found) ->
    callback(err) if (err)

    ## find one and update, or create if nonexistent
    if (!found)
      Sonar.create({
        name: opts.name,
        distance: parseFloat(opts.distance)
      }).exec (err, sonar) ->
       callback(err, sonar)

    else 
      Sonar.update( {name: opts.name}, { 
        name: opts.name,
        distance: parseFloat(opts.distance)
      }).exec (err, sonar) ->
        ## Bug fix as the update method appears to coerce float to string!!
        sonar[0].distance = parseFloat(sonar[0].distance)
        callback(err, sonar[0])


, retrieve: (opts, callback) ->
  SonarService.exists opts.name, (err, found) ->
    callback(err) if (err)

    ## Create and return new sonar entry if nonexistent
    if (!found)
      Sonar.create({
        name: opts.name,
        distance: 0.00
      }).exec (err, sonar) ->
       callback(err, sonar)

    ## Else return the sonar
    else 
      Sonar.findOne({ name: opts.name }).exec (err, sonar) ->
        sonar.distance = parseFloat(sonar.distance)
        callback(err, sonar)


, exists: (id, callback) ->
  Sonar.findOne({ name: id }).exec (err, sonar) ->
    callback(err) if err
    callback(null, sonar) 


