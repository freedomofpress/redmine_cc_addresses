require File.expand_path("../../test_helper", __FILE__)

class CcAddressesTest < ActiveSupport::TestCase
  fixtures :projects, :enabled_modules, :issues, :users,
           :email_addresses, :user_preferences, :members,
           :member_roles, :roles, :attachments, :tokens,
           :journals, :journal_details, :trackers, :projects_trackers,
           :issue_statuses, :enumerations, :versions

  setup do
    (@emails = ActionMailer::Base.deliveries).clear
    Setting.plain_text_mail = "1"
    Setting.default_language = "en"
    User.current = nil
    @journal = Journal.find 1
    @issue = @journal.journalized
    @project = @issue.project
    CcAddress.create! mail: "user@example.org", issue: @issue
  end

  test "should cc configured addresses" do
    @project.enabled_modules.create! name: "cc_addresses"
    Mailer.deliver_issue_edit(@journal)
    assert_equal 3, @emails.size
    assert @emails.any?{|m| m.bcc.include? "user@example.org" }
  end

  test "should not cc configured addresses if module isnt enabled" do
    Mailer.deliver_issue_edit(@journal)
    assert_equal 2, @emails.size
    assert @emails.none?{|m| m.bcc.include? "user@example.org" }
  end

  test "should filter mail to cc user if gpg enabled" do
    skip "openpgp plugin not installed" unless defined?(RedmineOpenpgp)
    @project.enabled_modules.create! name: "cc_addresses"
    with_settings(plugin_openpgp: {
      'activation' => 'all',
      'unencrypted_mails' => 'filtered',
      'filtered_mail_footer' => 'mail was filtered',
    }) do
      Mailer.deliver_issue_edit(@journal)
      assert_equal 3, @emails.size
      assert ccmail = @emails.detect{|m| m.bcc == ["user@example.org"]}
      assert ccmail.body.to_s.include? "mail was filtered"
    end
  end
end
