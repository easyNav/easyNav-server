NodeController = require("../../../api/controllers/SonarController")
sinon = require("sinon")
sails = require("sails")
request = require("superagent")

# request = require('supertest');
chai = require("chai")
assert = chai.assert
expect = chai.expect

describe "The Sonar Controller", ->

  beforeEach (done) ->
    # Clear nodes first
    request.get("http://localhost:1337/heartbeat/sonar/deleteAll").end (err, res) ->
      done()
  
  afterEach (done) ->
    done()

  describe "when requesting for sonar", ->

    it "should be able to view a list of sonars", (done) ->
      request.get("http://localhost:1337/heartbeat/sonar").end (err, res) ->
        expect(res.body).to.be.an "Array"
        done()


  describe 'when creating sonar records', ->

    it "should be able to create a new sonar record", (done) ->
      request.post("http://localhost:1337/heartbeat/sonar/sonar_left/?distance=20")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        done()

    it "should be able to update an existing sonar record", (done) ->
      request.post("http://localhost:1337/heartbeat/sonar/sonar_left/?distance=20")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        expect(res.body.name).to.equal('sonar_left')
        expect(res.body.distance).to.equal(20)

        request.post("http://localhost:1337/heartbeat/sonar/sonar_left/?distance=40")
        .end (err, res) ->
          expect(res.status).to.equal(200)
          expect(res.body.name).to.equal('sonar_left')
          expect(res.body.distance).to.equal(40)
          done()


    it "should be able to create new sonar records with different names", (done) ->
      ## Create a sonar record
      request.post("http://localhost:1337/heartbeat/sonar/sonar_right/?distance=80")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        expect(res.body.name).to.equal('sonar_right')
        expect(res.body.distance).to.equal(80)

        request.post("http://localhost:1337/heartbeat/sonar/sonar_left/?distance=20")
        .end (err, res) ->
          expect(res.status).to.equal(200)
          expect(res.body.name).to.equal('sonar_left')
          expect(res.body.distance).to.equal(20)
          done()


  describe 'when viewing sonar records', ->
    it "should be able to create a new sonar record, instantiated to 0, if nonexistent", (done) ->
      request.get("http://localhost:1337/heartbeat/sonar/sonar_center")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        expect(res.body.name).to.equal('sonar_center')
        expect(res.body.distance).to.equal(0)
        done()

    it "should be able to view an existing sonar record", (done) ->
      request.post("http://localhost:1337/heartbeat/sonar/sonar_left/?distance=70")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        expect(res.body.name).to.equal('sonar_left')
        expect(res.body.distance).to.equal(70)

        request.get("http://localhost:1337/heartbeat/sonar/sonar_left")
        .end (err, res) ->
          expect(res.status).to.equal(200)
          expect(res.body.name).to.equal('sonar_left')
          expect(res.body.distance).to.equal(70)
          done()


