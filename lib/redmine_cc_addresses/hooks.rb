module RedmineCcAddresses
  class Hooks < Redmine::Hook::ViewListener

    render_on :view_issues_show_description_bottom,
      partial: "issues/cc_addresses",
      if: :can_edit_cc_addresses?

    def can_edit_cc_addresses?(context)
      project = context[:project] and
        project.module_enabled?('cc_addresses') and
        User.current.allowed_to?(:edit_cc_addresses, project)
    end

  end
end
