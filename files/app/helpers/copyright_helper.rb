module CopyrightHelper
  def copyright_years
    year1 = 2016
    year2 = Date.today.year
    res="© #{t('app.company.short_name')}, "
    res += year1 == year2 ? "#{year1}" : "#{year1}–#{year2}"
    content_tag(:span, res)
  end
end
