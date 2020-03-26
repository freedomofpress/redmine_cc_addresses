require_dependency "user"

module RedmineCcAddresses
  module MailerPatch

    class CcAddressUser < ::AnonymousUser
      attr_accessor :mail
    end

    def self.apply
      unless Mailer < InstanceMethods
        Mailer.prepend InstanceMethods
        Mailer.singleton_class.prepend ClassMethods
      end
    end

    module InstanceMethods
      def process(action, *args)
        if action.to_s == "issue_edit" and args.first.is_a?(String)
          u = CcAddressUser.new
          u.mail = args.first
          super action, u, *(args[1..-1])
        else
          super
        end
      end
    end


    module ClassMethods
      def email_addresses(arg)
        Array.wrap(arg).flatten.map do |u|
          if u.is_a?(CcAddressUser)
            u.mail
          else
            super u
          end
        end.flatten
      end

      def deliver_issue_edit(journal)
        issue = journal.journalized
        if issue.project.module_enabled?(:cc_addresses)
          issue.cc_addresses.each do |cc_address|
            issue_edit(cc_address.mail, journal).deliver_later
          end
        end
        super
      end
    end

  end
end
