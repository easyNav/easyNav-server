/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `api/responses/notFound.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#/documentation/concepts/Routes/RouteTargetSyntax.html
 */

module.exports.routes = {

  /***************************************************************************
  *                                                                          *
  * Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, *
  * etc. depending on your default view engine) your home page.              *
  *                                                                          *
  * (Alternatively, remove this and add an `index.html` file in your         *
  * `assets` directory)                                                      *
  *                                                                          *
  ***************************************************************************/

  '/': {
    view: 'homepage'
  },

  '/dashboard': {
    view: 'dashboard'
  },

  /***************************************************************************
  *                                                                          *
  * Custom routes here...                                                    *
  *                                                                          *
  *  If a request to a URL doesn't match any of the custom routes above, it  *
  * is matched against Sails route blueprints. See `config/blueprints.js`    *
  * for configuration options and examples.                                  *
  *                                                                          *
  ***************************************************************************/


  // Node control.  Default blueprints used.
  'get /node/deleteAll': 'NodeController.deleteAll',
  'get /edge/deleteAll': 'EdgeController.deleteAll',
  'get /heartbeat/sonar/deleteAll': 'SonarController.deleteAll',
  'delete /edge': 'EdgeController.deleteBySuid',
  'get /map': 'MapController.show',
  'delete /map': 'MapController.destroy',
  'get /map/update': 'MapController.update',
  'get /map/shortest/:from/:to': 'MapController.getShortestPath',
  'get /map/nearest': 'MapController.getNearestNode',
  'get /map/goto/:to': 'MapController.goto',

  'get /heartbeat' : 'HeartbeatController.retrieve',
  'get /heartbeat/location' : 'LocationController.retrieve', 
  'post /heartbeat/location' : 'LocationController.update',
  'get /heartbeat/sonar/:name' : 'SonarController.retrieve', 
  'get /heartbeat/sonar' : 'SonarController.retrieveAll', 
  'post /heartbeat/sonar/:name' : 'SonarController.update'

};
