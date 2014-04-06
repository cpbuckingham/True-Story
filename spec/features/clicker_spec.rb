require 'spec_helper'

feature "Tracking student responses" do

  background do
    DB[:sessions].delete
    ClickerApp.sessions_repository = SessionRepository.new(DB)
  end

  scenario "Instructor sees how many students are in the class" do
    instructor_session = Capybara::Session.new(:selenium, ClickerApp)
    student_session = Capybara::Session.new(:selenium, ClickerApp)
    other_student_session = Capybara::Session.new(:selenium, ClickerApp)

    instructor_session.visit "/"
    instructor_session.click_on "I'm an Instructor"
    expect(instructor_session).to have_content("Lesson Overview")
    expect(instructor_session).to have_content("0 Students")

    student_session.visit "/"
    student_session.click_on "I'm a Student"
    expect(student_session).to have_content("Welcome, grasshopper!")

    instructor_session.visit instructor_session.current_path
    expect(instructor_session).to have_content("1")

    other_student_session.visit "/"
    other_student_session.click_on "I'm a Student"

    instructor_session.visit instructor_session.current_path
    expect(instructor_session).to have_content("2")

    other_student_session.click_on "You lost me"
    expect(instructor_session).to have_css(".student-circle.is-behind")

    student_session.click_on "I'm caught-up"
    expect(instructor_session).to have_css(".student-circle.is-caught-up")
  end

end