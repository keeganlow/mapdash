var SailsCollection = Backbone.Collection.extend({
  sailsCollection: "",
  socket: null,
  initialize: function () {
    // NOTE: this could also be handled in the sync method, but then we would
    //       duplicate all of this effort, each time sync gets called.
    if (typeof this.sailsCollection === "string" && this.sailsCollection !== "") {
      // TODO: obviate this io.connect()
      this.socket = io.connect();
      this.socket.on('connect', _.bind(function(){
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
    this.socket.request("/" + this.sailsCollection, where, _.bind(function(models){
      this.set(models);
    }, this));
  }
});
