var orchid = require('orchid');

module.exports = orchid.Client.extend({

    name: 'tea-service'

  , events: {
        'tea::log': 'logEvent'
    }

  , initialize: function () {

    }

  , logEvent: function (obj) {
      this._emit('log', obj);
    }
});
