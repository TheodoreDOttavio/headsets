class Shortlists
  include ActiveModel::Model

  attr_accessor :languages, :companies, :productCategories

  def initialize
    super
    languages = { Infrared: 0, iCaption: 1, dScript: 2, Chinese: 3, French: 4, German: 5, Japanese: 6, Portugese: 7, Spanish: 8, Turkish: 9 }
    @languages ||= languages

    companies = []
    companies.push(%w(Independent Independent))
    companies.push(%w(Disney Disney))
    companies.push(%w(Nederlander Nederlander))
    companies.push(%w(Jujamcyn Jujamcyn))
    companies.push(%w(Schubert Schubert))
    @companies ||= companies

    productCategories = {10 => "Infrared", 20 => "Loop", 30 => "Descriptive Audio", 40 => "iCaption", 50 => "Translation"}
    @productCategories ||= productCategories
  end
end
