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
    request.get("http://localhost:1337/sonar/deleteAll").end (err, res) ->
      done()
  
  afterEach (done) ->
    done()

  describe "when requesting for sonar", ->

    it "should be able to view a list of sonars", (done) ->
      request.get("http://localhost:1337/sonar").end (err, res) ->
        expect(res.body).to.be.an "Array"
        done()


  describe 'when creating sonar records', ->

    it "should be able to create a new sonar record", (done) ->
      request.post("http://localhost:1337/sonar/?name=sonar_1&distance=20")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        done()


    it "should be able to create new subsequent sonar records", (done) ->
      ## Create a sonar record
      request.post("http://localhost:1337/sonar/?name=sonar_1&distance=20")
      .end (err, res) ->
        expect(res.status).to.equal(200)

        ## Create another sonar record
        request.post("http://localhost:1337/sonar/?name=sonar_1&distance=20")
        .end (err, res) ->
          expect(res.status).to.equal(200)

          ## Ensure that there are ony 2 sonar records
          request.get("http://localhost:1337/sonar").end (err, res) ->
            expect(res.body).to.be.an "Array"
            expect(res.body.length).to.equal(2)
            done()

  describe 'when deleting sonar records', ->
    it "should be able to delete all sonar records", (done) ->
      request.post("http://localhost:1337/sonar/?name=sonar_1&distance=20")
      .end (err, res) ->
        expect(res.status).to.equal(200)
        done()

        ## Create a new sonar record
        request.post("http://localhost:1337/sonar/?name=sonar_1&distance=20")
        .end (err, res) ->
          expect(res.status).to.equal(200)

          ## Delete all sonars
          request.get("http://localhost:1337/sonar/deleteAll")
          .end (err, res) ->
            expect(res.status).to.equal(200)

            ## Ensure that there are no sonar records left
            request.get("http://localhost:1337/sonar").end (err, res) ->
              expect(res.body).to.be.an "Array"
              expect(res.body.length).to.equal(0)
              done()


