###*
MapService

@description :: Server-side logic for managing maps
@help        :: See http://links.sailsjs.org/docs/controllers
###

async = require 'async'

module.exports = view: (callback) ->
  HeartbeatSemaphore.findOne {id: 1}, (err, sm) ->
    callback(err) if err
    callback(err, sm) if sm
    if (!sm)
      HeartbeatSemaphore.create({
        x: 0
        y: 0
        val: 0
      }).exec(err, sm) ->
        sails.log 'reached'
        callback err, sm

, update: (opts, callback) ->
    HeartbeatSemaphore.update({id: 1}, {
      x: opts.x,
      y: opts.y, 
      val: opts.val
    }).exec (err, sm) ->
      callback err, sm
