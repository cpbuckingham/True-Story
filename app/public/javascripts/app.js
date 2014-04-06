InstructorApp = {
  setup: function () {
    this.getResults();
    setInterval(this.getResults, 1000);
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
            break;
          case 'behind':
            className = 'is-behind';
            break;
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
    $(document).on('click', '[data-behavior=ajax-button]', function(){
      $.post($(this).attr('href'));
      return false;
    });
  }
};
