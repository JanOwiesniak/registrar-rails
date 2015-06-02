require 'test_helper'

class CurrentProfileTest < ActionDispatch::IntegrationTest
  test 'exposes current profile if registrar.profile is avaliable' do
    get '/'
    current_profile = JSON.parse(response.body)
    expected = {"provider"=>{"name"=>"session", "uid"=>"1"}}
    assert_equal expected, current_profile
  end
end
