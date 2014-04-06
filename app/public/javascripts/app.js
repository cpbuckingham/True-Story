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
          case 'caught-up':
            className = 'is-caught-up';
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

$(document).on('click', 'a[data-remote=true]', function(){
  $.post($(this).attr('href'));
  return false;
});
