require 'redmine_cc_addresses/hooks'

module RedmineCcAddresses
  def self.setup
    RedmineCcAddresses::IssuePatch.apply
    RedmineCcAddresses::MailerPatch.apply
  end
end
