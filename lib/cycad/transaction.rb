require 'securerandom'

class Transaction
  attr_reader :id, :amount, :date, :note, :category_id

  def initialize(amount:, date:, note: nil, category_id:)
    @amount = amount
    @date = date
    @note = note
    @category_id = category_id
    @id = SecureRandom.uuid
  end
end
