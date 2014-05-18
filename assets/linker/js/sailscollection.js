var SailsCollection = Backbone.Collection.extend({
  sailsCollection: '',
  socket: null,
  initialize: function () {
    // NOTE: this could also be handled in the sync method, but then we would
    //       duplicate all of this effort, each time sync gets called.
    if (typeof this.sailsCollection === "string" && this.sailsCollection !== "") {
      this.socket = io.connect();

      this.socket.on('connect', _.bind(function(){

        // solution to subscribe to the appropriate collection's socket.io
        // room, without returning any data to the client by default
        // this solution allows Sails to handle the room subscription.
        // alternatively, we could do the subscription ourselves, but if a future
        // version of sails changed the room naming convention, we'd be out of
        // luck.
        this.socket.get('/' + this.sailsCollection, { where: { id: { '<': 0 } } });

        this.socket.on('message', _.bind(function(msg){
          var verb = msg.verb;
          if (verb === 'create') {
            this.add(msg.data);
          } else if (verb === 'update') {
            this.get(msg.data.id).set(msg.data);
          } else if (verb === 'destroy') {
            this.remove(this.get(msg.data.id));
          }
        }, this));
      }, this));
    } else {
      console.log("Error: Cannot retrieve models because property 'sailsCollection' not set on the collection");
    }
  },

  sync: function(method, model, options){
    var where = {};
    if (options.where) {
      where = { where: options.where };
    }
    // TODO: test this
    this.socket.request('/' + this.sailsCollection, where, _.bind(function(models){
      this.set(models);
    }, this));
  }
});
