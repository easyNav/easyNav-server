sinon = require("sinon")
sails = require("sails")
request = require("superagent")
chai = require("chai")
assert = chai.assert
expect = chai.expect
async = require('async')

# Clear nodes first
resetNodes = (cb) ->
  request.get("http://localhost:1337/node/deleteAll").end (err, res) ->
    request.get("http://localhost:1337/edge/deleteAll").end (err, res) ->
      request.post("http://localhost:1337/node/?name=bla&SUID=85&x=2&y=4&z=3").end (err, res) ->
        request.post("http://localhost:1337/node/?name=bla&SUID=90&x=3&y=1&z=8").end (err, res) ->
          cb()


describe "The Edge Controller", ->

  beforeEach (done) ->
    resetNodes ->
      done()
    
  afterEach (done) ->
    resetNodes ->
      done()

  describe "when creating new edges", ->

    it "should reject nodes from the same location", (done) ->
      request.post("http://localhost:1337/edge/?source=85&target=85&SUID=14&sourceColor=red&targetColor=blue").end (err, res) ->
        expect(res.status).to.eql(500)
        done()

    it "should reject non-existent nodes", (done) ->

      async.series({
        bothWrong: (cb) ->
          request.post("http://localhost:1337/edge/?source=994&target=995&SUID=14&sourceColor=red&targetColor=blue").end (err, res) ->
            expect(res.status).to.eql(500)
            cb()

        sourceWrong: (cb) ->
          request.post("http://localhost:1337/edge/?source=85&target=995&SUID=14&sourceColor=red&targetColor=blue").end (err, res) ->
            expect(res.status).to.eql(500)
            cb()

        targetWrong: (cb) ->
          request.post("http://localhost:1337/edge/?source=90&target=995&SUID=14&sourceColor=red&targetColor=blue").end (err, res) ->
            expect(res.status).to.eql(500)
            cb()
      },

      (err, results) ->
        expect(err).to.not.exist
        done()

      )

    it 'should not be created if edges two nodes already exist', (done) ->

      async.series({
        shouldPass: (cb) ->
          request.post("http://localhost:1337/edge/?source=90&target=85&SUID=14").end (err, res) ->
            expect(res.status).to.eql(200)
            cb()

        sourceTarget: (cb) ->
          request.post("http://localhost:1337/edge/?source=90&target=85&SUID=14").end (err, res) ->
            expect(res.status).to.eql(500)
            cb()

        sourceWrong: (cb) ->
          request.post("http://localhost:1337/edge/?source=85&target=90&SUID=14").end (err, res) ->
            expect(res.status).to.eql(500)
            cb()
      },

      (err, results) ->
        expect(err).to.not.exist 
        done()
      )

    it 'should be able to delete an edge', (done) ->

      async.series({
        createEdge: (cb) ->
          request.post("http://localhost:1337/edge/?source=90&target=85&SUID=14").end (err, res) ->
            expect(res.status).to.eql(200)
            cb()

        deleteEdge: (cb) ->
          request.del("http://localhost:1337/edge/?SUID=14").end (err, res) ->
            expect(res.status).to.eql(200)
            cb()
      },

      (err, results) ->
        expect(err).to.not.exist 
        done()
      )


      




  # describe 'when creating nodes', ->

  #   it "should be able to create a new node", (done) ->
  #     request.post("http://localhost:1337/node/?name=path&SUID=88")
  #     .end (err, res) ->
  #       create.log res.status
  #       expect(res.status).to.equal(200)
  #       done()

  #   it.skip "should reject nodes with the same SUID", (done) ->
  #     request.post("http://localhost:1337/node/?name=path&SUID=88")
  #     .end (err, res) ->
  #       sails.log.warn res.status
  #       expect(res.status).to.equal(200)

  #       request.post("http://localhost:1337/node/?name=bla&SUID=88")
  #       .end (err, res) ->
  #         sails.log res.status
  #         expect(res.status).to.equal(500);
  #         done()
