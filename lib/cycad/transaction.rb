class Transaction
  attr_accessor :id, :amount, :date, :note, :category_id

  def initialize(amount:, date:, note:, category_id:)
    @amount = amount
    @date = date
    @note = note
    @category_id = category_id
  end
end
