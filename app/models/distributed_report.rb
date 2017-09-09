class DistributedReport
  include Datagrid

  @my_language = { Infrared: 0, iCaption: 1, dScript: 2, Chinese: 3, French: 4, German: 5, Japanese: 6, Portugese: 7, Spanish: 8, Turkish: 9 }
  @my_theaters = { BigTheater: 2, SmallTheater: 5 }
  Theater.all.each do |t|
    @my_theaters[t.name.to_sym] = 1
  end
  @my_performances = { Showing: Performance.nowshowing.map { |a| [a.name, a.id] },
                       Dark: Performance.dark.map { |a| [a.name, a.id] } }

  scope do
    Distributed.delivered.order('curtain desc')
  end

  filter(:curtain, :date, range: true, header: 'Date')

  filter(:eve, :xboolean, header: 'Evening')

  filter(:product_id, :enum,
         select: proc { Product.where('options > 0').map { |a| [a.name, a.id] } },
         checkboxes: true)

  filter(:language, :enum,
         select: proc { @my_language },
         checkboxes: true)

  filter(:performance_id, :enum,
         select: proc { @my_performances },
         multiple: true,
         header: 'Shows')

  # filter(:performance_id, :enum,
  #   :select => proc { Performance.dark.map {|a| [a.name, a.id]}},
  #   :header => 'Dark')

  # filter(:performance_id, :enum,
  #   :select => proc { Performance.nowshowing.map {|a| [a.name, a.id]}},
  #   :header => 'Now Showing')

  # filter(:theater_id, :enum,  :multiple => true,
  #   :select => proc { Theater.where("id > 0").map {|a| [a.name, a.id]}},
  #   :header => 'Theater')

  # filter(:performance_id, :enum, :multiple => true,
  #  :select => proc { @my_theaters.sort },
  #  :header => 'Theater')

  # column_names_filter(:header => "Show Columns", :checkboxes => true)

  # column(:id)
  column(:performance, html: true, header: 'Theater') do |record|
    link_to record.performance.theater.name, record.performance.theater
  end

  column(:performance, html: true) do |record|
    link_to record.performance.name, record.performance
  end

  column(:product, html: true) do |record|
    link_to record.product.name, record.product
  end

  column(:product, header: 'Language') do |record|
    @my_language.key(record.language)
  end

  column(:quantity)

  column(:curtain) do |record|
    record.curtain.to_date
  end

  column(:eve, header: 'Eve/Mat') do
    eve? ? 'Eve' : 'Mat'
  end

  column(:performance, header: 'Closeing') do |record|
    if record.performance.closeing.to_date > DateTime.now
      :"Now Showing"
    else
      record.performance.closeing.to_date
    end
  end

  def my_language
    @my_language = { english: 0, iCaption: 1, dScript: 2, Chinese: 3, French: 4, German: 5, Japanese: 6, Portugese: 7, Spanish: 8, Turkish: 9 }
    @my_language
  end
end
