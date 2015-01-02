    # https://gist.github.com/dustMason/5817510
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
        html = html_tag
        html += %(<div class="form-field-error"> #{instance.error_message.to_a.to_sentence}</div>).html_safe unless html_tag =~ /^<label/
        html.html_safe
    end 