class Transaction
  attr_reader :id
  attr_accessor :amt, :date, :note, :cat_id

  def initialize(args)
    @id = args[:id]
    @amt = args[:amt]
    @date = args[:date]
    @note = args[:note]
    @cat_id = args[:cat_id]
  end
end
