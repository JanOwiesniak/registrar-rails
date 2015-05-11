require 'test_helper'

class CurrentProfileTest < ActionController::TestCase
  tests SomeController

  test 'no current profile by default' do
    get :index

    refute @controller.current_profile
    refute @controller.current_profile?
  end

end
