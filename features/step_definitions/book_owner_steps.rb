Given /^I am in the system$/ do
  @me = User.first
end

Given /^I logged in$/ do
  visit '/'
  # fill_in 'username', :with => @me.login
  # fill_in 'password', :with => @me.password
  # click_link 'login'
  # page.should have_content 'My page'
end

Given /^I have one own book$/ do
  pending
end

Given /^there is some others books$/ do
  pending
end

Given /^I made my book (in)?visible$/ do |is_visible|
  pending
end

Given /^my own book is (\w+)$/ do |status|
  pending
end

When /^I on my own book page$/ do
  pending
end

When /^I make my book (in)?visible$/ do |is_visible|
  pending
end

When /^I go on books page$/ do
  pending
end


Then /^I should( not)? see make book (in)?visible link$/ do |is_should, is_visible|
  pending
end

Then /^I should (not)? see my own book on books page$/ do |is_should|
  pending
end
