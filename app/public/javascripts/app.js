InstructorApp = {
  setup: function () {
    this.getResults();
    setInterval(this.getResults, 2000);
  },

  getResults: function () {
    $.getJSON('/instructor.json', function (data) {
      var $container = $("[data-behavior=student-container]");
      $container.empty();
      $.each(data, function (index, session) {
        var $span = $('<span class="student-index">' + index + '</span>');
        var className;
        switch (session.status) {
          case 'connected':
            className = 'is-connected';
        }
        var $div = $('<div class="student-circle"></div>');
        $div.addClass(className);
        $div.append($span);
        $container.append($div);
      });
    });
  }
};

StudentApp = {
  setup: function () {

  }
};
