/**
* Sonar.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {
  tableName: 'sonar',

  attributes: {
  	name: {
  		type: 'string',
      primaryKey: true,
  		required: true
  	},
  	distance: {
  		type: 'number',
  		required: true
  	}
  },

  beforeValidate: function (sonar, cb) {
    if (typeof sonar.distance === 'string') {
    	sonar.distance = parseFloat(sonar.distance);
    }
  	cb(null, sonar);
  }
};

