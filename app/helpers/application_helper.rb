module ApplicationHelper
	def nav_link(link_text, link_path, params={})
		if link_text == 'Sign Up' && controller.controller_name == 'confirmations'
			current_page = true
		elsif link_text=='Log In' && ['passwords','unlocks'].include?(controller.controller_name)
			current_page = true
		else
			current_page = current_page?(link_path)
		end
		
		li_class = ((params[:li_class] || '') + (current_page ? ' active' : '')).squish
		a_class = params[:a_class]
		method = params[:method]

	  content_tag(:li, :class => li_class) do
	  	link_to link_text, link_path, class: a_class, method: method
	  end
	end

  def glyph(*names)
    content_tag :i, nil, :class => names.map{|name| "glyphicon glyphicon-#{name.to_s.gsub('_','-')}" }
  end

  def api_meta_tags
  	if user_signed_in?
	  	"<meta content='#{current_user.email}' name='api_email' /><meta content='#{current_user.authentication_token}' name='api_token' />".html_safe
	  end
  end

  def humanize_user_attribute_name(attribute)
  	attribute.to_s.gsub(/^rcx_/,"").humanize
  end
end