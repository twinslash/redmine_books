Feature: To take book back to home
  I should to be able make book invisible

Background:
  Given I am in the system
  And I logged in
  And I have one own book
  And there is some others books

Scenario: make my own book invisible
  When I on my own book page
  And I make my book invisible
  Then I should see make book visible link
  When I go on books page
  Then I should not see my own book on books page

Scenario: make my own book visible
  Given I made my book invisible
  When I on my own book page
  And I make my book visible
  Then I should see make book invisible link
  When I go on books page
  Then I should  see my own book on books page

Scenario: cannot make invisible my own book that is busy
  Given my own book is busy
  When I on my own book page
  Then I should not see make book invisible link
