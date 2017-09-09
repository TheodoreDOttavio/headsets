class Archives
  include ActiveModel::Model
  extend ActiveModel::Naming

  attr_accessor :datamodels

  def initialize
    super
    datamodels = []
    datamodels.push(
      'modelname' => 'Distributed',
      'description' => 'Each product distributed'
    )
    datamodels.push(
      'modelname' => 'Performance',
      'description' => 'List of shows and performances'
    )
    datamodels.push(
      'modelname' => 'Cabinet',
      'description' => 'The inventory content of each console'
    )
    datamodels.push(
      'modelname' => 'Scan',
      'description' => 'db listing of scanned logs'
    )
    datamodels.push(
      'modelname' => 'User',
      'description' => 'All Users-representatives and Administrators. Will not re-import!'
    )
    datamodels.push(
      'modelname' => 'Available',
      'description' => 'User Availability'
    )
    datamodels.push(
      'modelname' => 'Theater',
      'description' => 'All Venues. A list of Theaters'
    )
    datamodels.push(
      'modelname' => 'Product',
      'description' => 'Inventory list - all products available'
    )

    # add the last time the model was changed
    datamodels.map do |modelhash|
      modelhash.store('changed',
                      eval(modelhash['modelname']).pluck(:updated_at).last)
    end

    datamodels.map do |modelhash|
      modelhash.store('recordcount',
                      eval(modelhash['modelname']).count)
    end

    @datamodels ||= datamodels
  end
end
