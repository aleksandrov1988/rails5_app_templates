module ApplicationHelper
  def try_l(object, options={})
    object.present? ? l(object, options) : object
  end

  def loader_tag
    fa_icon("circle-o-notch spin fw")
  end

end
