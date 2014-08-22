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
    
    # request(sails.hooks.http.app);
    done()
    return

  
  # NodeController.find().exec(function(err, results) {
  #     console.log(results);
  #     done();
  # });
  afterEach (done) ->
    done()
    return

  describe "when we load the node page", ->
    it "should render the view", ->
      request.get("http://localhost:1337/node").end (err, res) ->
        sails.log res.body
        expect(res.body).to.be.an "Array"
        return

      return

    return

  return
