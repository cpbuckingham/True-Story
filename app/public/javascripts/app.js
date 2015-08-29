InstructorApp = {
  setup: function (pubsub, location) {
    this.pubsub = pubsub;
    this.location = location;
    this.getResults();
    this.subscribe();
    this.container = $("[data-behavior=student-container]");
    this._students = {};
  },

  getResults: function () {
    var that = this;
    var boot_url = '/' + this.location + '/scrum_master.json';


    $.getJSON(boot_url, function(data) {
      that._students = data;
      that.render();
    });
  },

  render: function () {
    this.renderSummary(this.students());
    this.renderDetails(this.students());
  },

  subscribe: function () {
    var channel = this.pubsub.subscribe(this.location);

    channel.bind('update', $.proxy(this.updateStudent, this));
    channel.bind('delete_all', $.proxy(this.clearStudents, this));
  },

  updateStudent: function (data) {
    this._students[data.uuid] = data;
    this.render();
  },

  clearStudents: function() {
    this._students = {};
    this.render();
  },

  renderSummary: function (data) {
    var $summary = $("[data-container=student-summary]");
    var ending = data.length == 1 ? '' : 's';
    $summary.html(data.length + ' Developer' + ending);
  },

  renderDetails: function (data) {
    this.container.empty();
    $.each(data, $.proxy(this.addStudent, this));
  },

  addStudent: function (index, session) {
    var $span = $('<span class="student-index">' + index + '</span>');
    var $div = $('<div class="student-circle"></div>');
    var className = this.getClassName(session);
    $div.addClass(className).append($span);
    this.container.append($div);
  },

  getClassName: function (session) {
    switch (session.status) {
      case 'connected':
        return 'is-connected';
      case 'behind':
        return 'is-behind';
      case 'caught-up':
        return 'is-caught-up';
    }
  },

  students: function() {
    return _.values(this._students);
  }
};

StudentApp = {
  setup: function () {
    var $studentStatusDiv = $("[data-behavior=student-status]");
    $(document).on("click", "[data-behavior=you-lost-me]", function () {
      $studentStatusDiv.addClass("is-lost").removeClass("is-caught-up");
    });
    $(document).on("click", "[data-behavior=caught-up]", function () {
      $studentStatusDiv.addClass("is-caught-up").removeClass("is-lost");
    });
  }
};

$(document).on('click', 'a[data-remote=true]', function () {
  $.post($(this).attr('href'));
  return false;
});
