InstructorApp = {
  setup: function () {
    this.getResults();
    setInterval($.proxy(this.getResults, this), 1000);
  },

  getResults: function () {
    $.getJSON('/instructor.json', $.proxy(this.render, this));
  },

  render: function (data) {
    this.renderSummary(data);
    this.renderDetails(data);
  },

  renderSummary: function (data) {
    var $summary = $("[data-container=student-summary]");
    var ending = data.length == 1 ? '' : 's';
    $summary.html(data.length + ' Student' + ending);
  },

  renderDetails: function (data) {
    var that = this;
    var $container = $("[data-behavior=student-container]");
    $container.empty();
    $.each(data, function (index, session) {
      var $span = $('<span class="student-index">' + index + '</span>');
      var $div = $('<div class="student-circle"></div>');
      var className = that.getClassName(session);
      $div.addClass(className).append($span);
      $container.append($div);
    });
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
