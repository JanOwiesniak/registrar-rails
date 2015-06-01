require 'test_helper'

class CurrentProfileTest < ActionDispatch::IntegrationTest
  test 'exposes current profile if registrar.profile is avaliable' do
    get '/'
    current_profile_uid = response.body
    assert_equal '1', current_profile_uid
  end
end
