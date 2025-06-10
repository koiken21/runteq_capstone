require "test_helper"

class OrganizationSettingsTest < ActionDispatch::IntegrationTest
  def setup
    @org1 = Organization.create!(name: "Org1")
    @admin = User.create!(name: "Admin", mail_address: "admin@example.com", role: "admin", organization: @org1, password: "password")
    @org2 = Organization.create!(name: "Org2")
    @supporter = User.create!(name: "Supporter", mail_address: "supporter@example.com", role: "supporter", organization: @org2, password: "password")
  end

  test "admin creates organization and assigns to self" do
    post login_path, params: { session: { mail_address: @admin.mail_address, password: "password" } }
    get new_organization_setting_path
    assert_response :success

    assert_difference("Organization.count") do
      post organization_setting_path, params: { organization: { name: "New Org" } }
    end
    assert_redirected_to tasks_path
    follow_redirect!
    assert_equal "New Org", @admin.reload.organization.name
  end

  test "supporter selects existing organization" do
    org3 = Organization.create!(name: "Other Org")

    post login_path, params: { session: { mail_address: @supporter.mail_address, password: "password" } }
    get edit_organization_setting_path
    assert_response :success

    patch organization_setting_path, params: { user: { organization_id: org3.id } }
    assert_redirected_to tasks_path
    follow_redirect!
    assert_equal org3, @supporter.reload.organization
  end
end
