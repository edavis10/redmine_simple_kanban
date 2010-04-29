module SimpleKanbansHelper
  def next_issue_title
    if @filtered_user
      content_tag(:h2, l(:simple_kanban_text_next_issue_for, :user => h(@filtered_user.name)))
    else
      content_tag(:h2, l(:simple_kanban_text_next_issue))
    end
  end
end
