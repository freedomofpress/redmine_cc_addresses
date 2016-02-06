class ShowCcAddressesHook < Redmine::Hook::ViewListener
  render_on :view_issues_show_description_bottom, :partial => "issues/cc_addresses", :if => :can_view_cc_addresses?
  render_on :view_issues_form_details_bottom, :partial => "issues/cc_addresses", :if => :can_add_cc_addresses?

  def controller_issues_new_prepare(context = {})
    num_cc_fields = (context[:params][:num_cc_fields].to_i != 0) ? context[:params][:num_cc_fields].to_i : 1
    if (can_add_cc_addresses?(context))
      num_cc_fields.times do
        #context[:issue].cc_addresses.build
      end
    end
  end
    
private
  def protect_against_forgery?
    false
  end

  def can_view_cc_addresses?(context)
    context[:project].module_enabled?('cc_addresses') and User.current.allowed_to?(:view_cc_addresses, context[:project])
  end

  def can_add_cc_addresses?(context)
    context[:project].module_enabled?('cc_addresses') and User.current.allowed_to?(:add_cc_addresses, context[:project]) and context[:issue].new_record?
  end  
end
