NodeController = require("../../../api/controllers/NodeController")
sinon = require("sinon")
sails = require("sails")
request = require("superagent")

# request = require('supertest');
chai = require("chai")
assert = chai.assert
expect = chai.expect

describe "The Node Controller", ->

  beforeEach (done) ->
    # Clear nodes first
    request.get("http://localhost:1337/node/deleteAll").end (err, res) ->
      done()
  
  afterEach (done) ->
    done()

  describe "when requesting for nodes", ->

    it "should be able to view new nodes", (done) ->
      request.get("http://localhost:1337/node").end (err, res) ->
        # sails.log res.body
        expect(res.body).to.be.an "Array"
        done()


  describe 'when creating nodes', ->

    it "should be able to create a new node", (done) ->
      request.post("http://localhost:1337/node/?name=path&SUID=88&x=2&y=4&z=3")
      .end (err, res) ->
        sails.log res.status
        expect(res.status).to.equal(200)
        done()

    it.skip "should reject nodes with the same SUID", (done) ->
      request.post("http://localhost:1337/node/?name=path&SUID=88&x=2&y=4&z=3")
      .end (err, res) ->
        sails.log.warn res.status
        expect(res.status).to.equal(200)

        request.post("http://localhost:1337/node/?name=bla&SUID=88&x=2&y=4&z=3")
        .end (err, res) ->
          sails.log res.status
          expect(res.status).to.equal(500);
          done()
